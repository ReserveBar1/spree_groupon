Deface::Override.new(:virtual_path => "spree/admin/orders/show",
                     :name => "admin_orders_add_groupon_promo_code",
                     :insert_top => "[data-hook='admin_order_show_details']",
                     :partial => "/spree/admin/orders/groupon_promo_code",
                     :disabled => false)
                     
Deface::Override.new(:virtual_path => "spree/admin/promotions/index",
                      :name => "admin_promotions_submenu",
                      :insert_before => ".toolbar",
                      :partial => "/spree/admin/promotions/sub_menu",
                      :disabled => false)
