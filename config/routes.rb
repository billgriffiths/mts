Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  
  root "admin#index"
  
  resources :users, :students, :instructors, :courses, :test_templates, :answer_records, :test_results
  
  get "admin/try-test" => "admin#try_test"
  get "admin/authorize" => "admin#authorize"
  get "admin/add_student_to_course" => "admin#add_student_to_course"
  get "admin/get_student_record" => "admin#get_student_record"
  get "admin/authorize_reentry" => "admin#authorize_reentry"
  get "admin/logout" => "admin#logout"
  get "students/get_test" => "students#get_test"
  get "students/choose_student" => "students#choose_student"
  get "students/authorize" => "students#authorize"
  get "test_templates/upload" => "test_templates#upload"
  get "answer/analyze_answers" => "answer#analyze_answers"

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
