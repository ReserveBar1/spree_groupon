Spree::Admin::PromotionsController.class_eval do
  
  # use regular before_filter to load up the groupon style attributes
  before_filter :load_groupon_style_attributes, :only => [:edit]
  
  # need to extend the controller so that it handles uploading of groupon codes and setting of the campaign
  create.before :remove_groupon_attributes
  update.before :remove_groupon_attributes
  
  # after saving the promotion, if this is a groupon style promo, store the groupon codes
  create.after :store_groupon_codes
  
  update.after :update_groupon_codes
  
  protected
  
  def remove_groupon_attributes
    @groupon_campaign = params[:promotion][:groupon_campaign] ? params[:promotion].delete(:groupon_campaign) : nil
    @groupon_codes_file = params[:promotion][:groupon_codes_file] ? params[:promotion].delete(:groupon_codes_file) : nil
  end
  
  # params["promotion[groupon_codes_file]"] has the upload file with one groupon code per line
  def store_groupon_codes
    if @promotion.is_groupon_style? && @groupon_codes_file
      Rails.logger.warn("Promo is groupon style : #{@promotion.id}")
      successful_imports = 0
      unsuccessful_imports = 0
      data = @groupon_codes_file.read
      CSV.parse(data) do |row|
        next if row.join.blank?
        begin
          Spree::GrouponCode.create(:code => row[0], :activator_id => @promotion.id, :campaign => @groupon_campaign)
          successful_imports = successful_imports + 1
        rescue
          unsuccessful_imports = unsuccessful_imports + 1
        end
      end
      Rails.logger.warn("Imported: #{successful_imports}, failed: #{unsuccessful_imports}")
    end
  end
  
  def update_groupon_codes
    # if there is a new file uploaded, delete old codes and put new codes in place.
    if @promotion.is_groupon_style?
      if @groupon_codes_file
        # remove old coupons and save new ones
        @promotion.groupon_codes.destroy_all if @promotion.groupon_codes.count > 0
        store_groupon_codes
      else
        # update campaign name if changed, but no new coupons file submittted
        @promotion.groupon_codes.update_all(:campaign, @groupon_campaign)
      end
    end
  end
  
  def load_groupon_style_attributes
    if @promotion.is_groupon_style?
      begin
        @promotion.groupon_campaign = @promotion.groupon_codes.first.campaign
        @number_of_groupon_codes = @promotion.groupon_codes.count
      rescue
        @promotion.groupon_campaign = ""
        @number_of_groupon_codes = 0
      end
    end
  end
  
end