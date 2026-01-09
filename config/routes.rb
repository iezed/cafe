Rails.application.routes.draw do
  root 'orders#new'

  resources :products
  resources :orders
  resources :points
  resources :user_branches


  # 관리사용자
  devise_for :users, :controllers => {:omniauth_callbacks=>'users/omniauth_callbacks', :sessions => "users/sessions",:registrations => "users/registrations",:passwords => "users/passwords"}, :path_names =>  {:sign_up=>'new',:sign_in => 'login', :sign_out => 'logout'}

  # 관리사용자
  devise_for :admins, :controllers => {:sessions => "admins/sessions",:registrations => "admins/registrations" }, :path_names =>  {:sign_up=>'new',:sign_in => 'login', :sign_out => 'logout'}

  # 관리자
  scope 'admin', module: 'admin', as: 'admin' do
    get '/' => 'orders#index', as: 'admin_root'
    get 'branches/switch/:id', :to=>'branches#switch', as: 'branch_switch'

    resources :admins
    resources :accounts
    resources :product_categories
    resources :products
    resources :orders
    resources :groups
    resources :users
    resources :points
    resources :branches
  end
end
