Rails.application.routes.draw do
  get 'sessionsgem/install'

  get 'sessionsgem/bcrypt'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  
  root "admin#index"
  
  match "test_templates/upload" => "test_templates#upload", via: [:get, :post]
  match "test_templates/save" => "test_templates#save", via: [:get, :post]
  match "students/get_test" => "students#get_test", via: [:get, :post]
  match "students/choose_student" => "students#choose_student", via: [:get, :post]
  match "students/show_record" => "students#show_record", via: [:get, :post]
  get "students/authorize" => "students#authorize"
  post "students/authorize_test" => "students#authorize_test"
  get "test_templates/" => "test_templates#index"
  get "users/add" => "users#add"
  get "test_taker/show_test" => "test_taker#show_test"
  get "test_results/show_test" => "test_results#show_test"
  match "test_results/score" => "test_results#score", via: [:get, :post]
  
  resources :users, :instructors, :courses, :answer_records, :test_results, :test_templates, :students
  
  get "admin/" => "admin#index"
  match "admin/choose_student" => "students#choose_student", via: [:get, :post]
  get "admin/try-test" => "admin#try_test"
  match "admin/try_test" => "admin#try_test", via: [:get, :post]
  get "admin/authorize" => "admin#authorize"
  get "admin/add_student_to_course" => "admin#add_student_to_course"
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
