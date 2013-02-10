Spree::Adjustment.class_eval do

  # Helper to determine if this adjustment was caused by a groupn style promo:
  def is_due_to_groupon_style_promo?
    (self.originator_type == "Spree::PromotionAction") && self.originator.promotion.is_groupon_style?
  end
  
end
