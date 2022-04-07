Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'
  get "user/index"
  get "user/edit"
  get "user/new"
  post "user/edit"
  get "user/delete"

  get "user/change_password"
  post "user/change_password"

  post "user/new"
  get "user/view"
  get "/logout" => 'user#logout'
  get "/login" => "user#login"
  post "/login" => "user#login"

  get "user/roles"
  get "user/permissions"

  get "user/new_role"
  get "user/edit_role"
  get "user/edit_role"
  post "user/edit_role"
  post "user/new_role"
  get "user/delete_role"
  get "user/view_role"


  get "user/user_roles"
  post "user/user_roles"

  get "client/new_type"
  post "client/new_type"

  get "client/edit_type"
  post "client/edit_type"

  get "client/view_type"
  get "client/delete_type"

  get "client/index"
  get "client/ajax_clients"

  get "client/new"
  post "client/new"

  get "client/edit"
  post "client/edit"

  get "client/view"
  get "module/view_module"

  get "client/client_suggestions"

  get "/complaints/:client_id" => "encounter#complaints"
  post "/create/:client_id" => "encounter#create"

  get "/hiv_test_result/:client_id" => "encounter#hiv_test_result"
  get "/viral_load_result/:client_id" => "encounter#viral_load_result"
  get "/vitals/:client_id" => "encounter#vitals"
  get "/prescribe/:client_id" => "drug#prescribe"
  get "/dispense/:client_id" => "drug#dispense"
  get "/outcomes/:client_id"  => "encounter#outcomes"

  get "/configs/:module" => "configuration#index"

  get "/lab_departments" => "configuration#lab_departments"
  get "/new_department" => "configuration#new_department"
  get "/edit_department" => "configuration#edit_department"

  post "/new_department" => "configuration#new_department"
  post "/edit_department" => "configuration#edit_department"
end
