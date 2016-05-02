Proctor::Application.routes.draw do
  resources :supervisors


	get "enrollments/create"

	get "enrollments/destroy"

	get "report/index"
	get 'report/tickets'
	post 'report/tickets'
	get 'report/supervisors'
	post 'report/supervisors'
	get 'report/attendance'
	post 'report/attendance'
	get 'report/unpaid'
	post 'report/unpaid'
	get 'report/exams'
	post 'report/exams'
	get 'report/lock'
	post 'report/lock'
	get 'report/reset'
	post 'report/reset'

	resources :payments

	resources :students do
		get 'import', :on => :collection
		post 'import', :on => :collection
		post 'operate', :on => :collection
		get 'self', :on => :collection
		post 'self', :on => :collection
		get 'email', :on => :member
	end

	resources :enrollments

	resources :exams
	resources :users
	resources :sessions do
		get 'delete' => "sessions#destroy", :on => :collection
	end	

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
	root :to => 'report#index'

	# See how all your routes lay out with "rake routes"

	# This is a legacy wild controller route that's not recommended for RESTful applications.
	# Note: This route will make all actions in every controller accessible via GET requests.
	# match ':controller(/:action(/:id))(.:format)'
end
