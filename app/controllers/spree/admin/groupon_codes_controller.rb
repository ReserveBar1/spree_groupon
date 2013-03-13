module Spree
  module Admin
    class GrouponCodesController < ResourceController

      respond_to :html
      def index
        respond_with(@collection)
      end
      
      protected
	
    	def collection
        return @collection if @collection.present?

        @search = GrouponCode.metasearch(params[:search])
        @collection = @search.relation.page(params[:page]).per(Spree::Config[:admin_products_per_page])
 
      end
      
    end
  end
end
