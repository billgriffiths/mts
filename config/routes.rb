Rails.application.routes.draw do

  get 'sessionsgem/install'

  get 'sessionsgem/bcrypt'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  
  root "welcome#index"
  
  match "test_templates/upload" => "test_templates#upload", via: [:get, :post]
  match "test_templates/save" => "test_templates#save", via: [:get, :post]
  match "students/get_test" => "students#get_test", via: [:get, :post]
  match "students/choose_student" => "students#choose_student", via: [:get, :post]
  match "students/show_record" => "students#show_record", via: [:get, :post]
  get "students/authorize" => "students#authorize"
  post "students/authorize_test" => "students#authorize_test"
  match "students/authorize_reentry" => "students#authorize_reentry", via: [:get, :post]
  post "students/authorize_reentry_test" => "students#authorize_reentry_test"
  get "test_templates/" => "test_templates#index"
  get "test_templates/show_test" => "test_templates#show_test"
  get "test_templates/destroy" => "test_templates#destroy"
  get "users/add" => "users#add"
  get "test_taker/show_test" => "test_taker#show_test"
  get "test_results/show_test" => "test_results#show_test"
  match "test_results/score" => "test_results#score", via: [:get, :post]
  match "courses/remove_student" => "courses#remove_student", via: [:get, :post]
  
  delete "users/:id" => "users#destroy"
  delete "users" => "users#destroy"
  
  resources :users, :instructors, :courses, :answer_records, :test_results, :test_templates, :students
  
  match "/login" => "admin#login", via: [:get, :post]
  match "/admin" => "admin#login", via: [:get, :post]
  match "answer/analyze_test" => "answer#analyze_test", via: [:get, :post]
  match "answer/analyze_problem" => "answer#analyze_problem", via: [:get, :post]
  match "admin/choose_student" => "students#choose_student", via: [:get, :post]
  get "admin/index" => "admin#index"
  get "admin/try-test" => "admin#try_test"
  match "admin/try_test" => "admin#try_test", via: [:get, :post]
  get "admin/authorize" => "admin#authorize"
  match "admin/authorize_class" => "admin#authorize_class", via: [:get, :post]
  match "admin/authorize_class_test" => "admin#authorize_class_test", via: [:get, :post]
  get "admin/authorize_class_test" => "admin#authorize_class_test"
  match "admin/add_student_to_course" => "admin#add_student_to_course", via: [:get, :post]
  get "admin/get_student_record" => "admin#get_student_record"
  get "admin/authorize_reentry" => "admin#authorize_reentry"
  get "admin/logout" => "admin#logout"
  match "admin/login" => "admin#login", via: [:get, :post]
  get "admin/list_users" => "admin#list_users"
  get "admin/destroy_user" => "admin#destroy_user"
  get "admin/new_user" => "admin#new_user"
  get "admin/edit_user" => "admin#edit_user"
  get "admin/add_user" => "admin#add_user"
  get "admin/add_course" => "admin#add_course"
  match "admin/add_test_to_course" => "admin#add_test_to_course", via: [:get, :post]
  get "admin/show_test_try" => "admin#show_test_try"
  get "admin/test_results" => "admin#test_results"
  match "admin/show_test_results" => "admin#show_test_results", via: :post
  match "admin/score_try" => "admin#score_try", via: [:get, :post]
  match "admin/update_answers" => "admin#update_answers", via: [:get, :post]
  match "admin/add_students" => "admin#add_students", via: [:get, :post]
  match "admin/show_class" => "admin#show_class", via: [:get, :post]
  match "test_taker/update_answers" => "test_taker#update_answers", via: [:get, :post]
  get "answer/analyze_answers" => "answer#analyze_answers"
  get "instructor/create" => "instructor#create"

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
