Ftwgl::Application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  get 'discourse/sso' => 'discourse_sso#sso'

  resources :news, :only => [:show] do
    resources :comments, :only => [ :create ]
  end
  resources :user, only: [:show, :index]
  resources :teams, only: [:new, :create, :show, :edit, :update, :index]
  resources :memberships, only: [:create, :update, :destroy, :index]
  resources :tournaments, only: [:new, :create, :show, :index] do
    get '/rankings' => 'tournaments#rankings'
    resources :matches, only: [:index, :show, :edit, :update] do
      resources :comments, only: [ :create ]
    end
  end
  resources :tournament_teams, only: [:show, :create]
  resources :tournament_team_memberships, only: [:new, :create, :update, :destroy]
  namespace :admin do
    root :to => 'cpanel#index'
    resources :users, :only => [:edit, :update, :destroy] do
      put 'ban'
      put 'unban'
    end
    resources :news, :only => [:new, :create, :edit, :update, :destroy]
    resources :memberships, :only => [:destroy]
    resources :teams, :only => [:edit, :update, :destroy]
    resources :tournaments do
      put 'deactivate'
      put 'activate'
      put 'start_bracket'
      get 'bracket_results'
      get 'playoffs'
      post 'generate_playoff_bracket'
      put 'update_bracket'
      get 'bracket_matches'
      post 'generate_bracket_matches'
      collection do
        get "rankings"
        put "update_rankings"
        get "schedule"
        post "create_schedule"
      end
    end
    resources :tournament_teams, :only => [:index, :new, :create, :edit, :update, :destroy]
    resources :matches
  end

  root :to => 'home#home'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
