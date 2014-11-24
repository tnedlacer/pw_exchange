Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  
  root 'index#index'
  
  namespace :pw_requests do
    get "", action: :form, as: "form"
    post "create", action: :create, as: ""
    get "list/:list_token/:key", action: :list, as: "list"
    post "authentication", action: :authentication, as: "authentication"
  end
  
  namespace :pw_responses do
    get "form/:form_token/:key", action: :form, as: "form"
    post "create/:form_token/:key", action: :create, as: "create"
    get "show/:code/:key", action: :show, as: "show"
  end
  
  namespace :pw_senders do
    get "", action: :form, as: "form"
    post "create", action: :create, as: ""
  end
  
  namespace :pw_recipients do
    get ":form_token/:key", action: :form, as: "form"
    post "send_mail/:form_token/:key", action: :send_mail, as: "send_mail"
    post "show/:form_token/:key", action: :show, as: "show"
  end
 
end
