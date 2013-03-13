Spree::Core::Engine.routes.append do

  namespace :admin do
    
    resources :groupon_codes
    
  end
  
end
