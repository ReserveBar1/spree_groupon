Spree::CheckoutController.class_eval do
  
  # Ajax call to apply coupon to order
  # We add the handling of the groupons here, need to do a different check and fire off a different event.
  def apply_coupon
    if @order.update_attributes(object_params)

      if @order.coupon_code.present?
                
        
        # Code for regular promotions
        if (Spree::Promotion.exists?(:code => @order.coupon_code))
          if (Spree::Promotion.where(:code => @order.coupon_code).last.eligible?(@order) && Spree::Promotion.where(:code => @order.coupon_code).last.order_activatable?(@order))
            fire_event('spree.checkout.coupon_code_added', :coupon_code => @order.coupon_code)
            # If it doesn't exist, raise an error!
            # Giving them another chance to enter a valid coupon code
            @message = "Coupon applied"
          else
            # Check why the coupon cannot be applied (at least a few checks)
            promotion = Spree::Promotion.where(:code => @order.coupon_code).last
            if promotion.expired?
              @message = "The coupon is expired or not yet active."
            elsif promotion.usage_limit_exceeded?(@order)
              @message = "The coupon cannot be applied, it's usage limit has been exceeded."
            elsif promotion.created_at.to_i > @order.created_at.to_i
              @message = "The coupon cannot be applied because it has been created after the order."
            else
              @message = "The coupon cannot be applied to this order."
            end
          end
          
        # Code for groupon style promotions
        elsif  Spree::GrouponCode.exists?(:code => @order.coupon_code)
          groupon_code = Spree::GrouponCode.where(:code => @order.coupon_code).first
          promotion = groupon_code.promotion
          if (promotion.eligible?(@order) && promotion.order_activatable?(@order))
            fire_event('spree.checkout.groupon_code_added', :coupon_code => @order.coupon_code)
            # If it is not valid or has already been used raise an error!
            @message = "Coupon applied"
          else
            if promotion.expired?
              @message = "The coupon is expired or not yet active."
            elsif groupon_code.used_at
              @message = "This coupon has already been used on another order."
            elsif promotion.usage_limit_exceeded?(@order)
              @message = "The coupon cannot be applied, it's usage limit has been exceeded."
            elsif promotion.created_at.to_i > @order.created_at.to_i
              @message = "The coupon cannot be applied because it has been created after the order."
            else
              @message = "The coupon cannot be applied to this order."
            end
          end
        else
          @message = t(:promotion_not_found)
        end
      end
      # Need to reload the order, otherwise total is not updated
      @order.reload
      respond_with(@order, @message)
    end
  end
  
end
