Ipams::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # i18n
  scope '(:locale)' do
    devise_for :system_users
    root 'welcome#index', as: 'welcome'
    #resources :lans, :addresses, :reserved_addresses, :departments, :users, :histories
    resources :lans, :reserved_addresses, :departments, :users, :histories
    resources :vlans do
      collection { post :import }
    end

    resources :addresses do
      member { put :recycle }
    end

    get "import/index"
    get "import/import"
    post "import/import"
    get "export/index"
    get "export/export"
    post "export/export"
    get "welcome/index"
    get "help/index"
    get "search/index"

    # Template downloads
    get "import/vlan_importing_template"
    get "import/ip_address_importing_template"
  end

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
end
