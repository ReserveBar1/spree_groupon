module Spree
  module Groupon
    class Engine < Rails::Engine
      isolate_namespace Spree
      engine_name "spree_groupon"
      
      def self.activate
        Dir.glob(File.join(File.dirname(__FILE__), "../../../app/overrides/*.rb")) do |c|
          Rails.application.config.cache_classes ? require(c) : load(c)
        end
        
        Dir.glob(File.join(File.dirname(__FILE__), '../../../app/**/*_decorator*.rb')) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end
        
      end

      config.autoload_paths += %W(#{config.root}/lib)
      config.to_prepare &method(:activate).to_proc
      
      # initializer 'spree.promo.register.promotion.calculators', :after => 'spree.promo.environment' do |app|
      #   app.config.spree.calculators.promotion_actions_create_adjustments << Spree::Calculator::PercentItemTotalWithCap
      # end
      # 
      # initializer 'spree.promo.register.promotion.rules', :after => 'spree.promo.environment' do |app|
      #   app.config.spree.promotions.rules << Spree::Promotion::Rules::NumberOfItems
      # end
      

       
    end

  end
end
