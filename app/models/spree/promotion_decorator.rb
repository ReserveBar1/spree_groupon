Spree::Promotion.class_eval do
  
  # New event type for groupon type codes - allows us to differentiate later on
  Spree::Activator.event_names << 'spree.checkout.groupon_code_added'

  has_many :groupon_codes, :foreign_key => 'activator_id', :dependent => :destroy
  attr_accessor :groupon_campaign
  attr_accessor :groupon_codes_file

  
  
  # Override the activate function (called after fire_event) so it handles the case where a groupon style promo i done
  # The coupon_code is stored in the same spot in the order as a regular promo code, we just determine which event to fire
  def activate(payload)
    return unless order_activatable? payload[:order]

    # Regular style promotion with single code per promo
    if code.present?
      event_code = payload[:coupon_code].to_s.strip.downcase
      return unless event_code == self.code.to_s.strip.downcase
    end
    
    # Regular content based promo
    if path.present?
      return unless path == payload[:path]
    end
    
    # Groupon style promo - check if order.coupon_code is associated with this promotion and has not already been used.
    if payload[:event_name] == 'spree.checkout.groupon_code_added'
      return unless groupon_codes.unused.where(:code => payload[:coupon_code])
      # There may be more than one groupon campaign active at any one time, and there mau be more than one activator selected, so guard against that
      return unless id == payload[:promotion_id]
    end

    actions.each do |action|
      action.perform(payload)
    end
    
    # For groupon style codes - mark them as used after the action have been applied
    if payload[:event_name] == 'spree.checkout.groupon_code_added'
      begin
        groupon_code = Spree::GrouponCode.where(:code => payload[:coupon_code]).first
        groupon_code.update_attributes(:used_at => Time.now, :order_id => payload[:order].id)
      rescue
        raise "Can't update groupon code - please check"
      end
    end
  end
  
  
  def is_groupon_style?
    self.event_name == 'spree.checkout.groupon_code_added'
  end
  
  
  
  
end