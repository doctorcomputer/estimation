Estimating::Application.routes.draw do

	# Static pages
	root :to => "static#index"
  match 'how_it_works' => 'static#how_it_works'
  match 'info/:action' => 'static'

  # Public site workflow
  match 'index' => 'site#index', :as => :index
  match 'request_detail/:id' => 'site#request_detail', :as => :request_detail
  match 'proposal_submission' => 'site#proposal_submission', :as => :proposal_submission
  match 'proposal_new/:id' => 'site#proposal_new', :as => :proposal_new

  # Personal requests
  resources :requests
  match 'personal_index' => 'requests#personal_index'
  match 'search_requests' => 'requests#search'
  match 'set_best_proposal' => 'requests#set_best_proposal', :as => :set_best_proposal, :via => :post

  # Personal proposals
  resources :proposals

  # Personal favourite categories
  resources :favourite_categories
  match 'interesting_requests' => 'favourite_categories#interesting_requests', :as => :interesting_requests

  # User and login related
  resources :users
  resources :user_sessions
	match 'login' => 'user_sessions#new'
	match 'logout' => 'user_sessions#destroy'
  match 'activation' => 'user_sessions#activation' # Shows the form in which the user could paste the activation code
  match 'activate' => 'user_sessions#activate' # Activate the account





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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
