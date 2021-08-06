Rails.application.routes.draw do
  root  'static_pages#home'
  # rootは一番初めに立ち上げた時に開くページを指定する。
  get   '/help',    to:'static_pages#help'
  get   '/about',   to:'static_pages#about'
  get   '/contact', to:'static_pages#contact'
  
  get   '/signup',  to:'users#new'
  
  get   '/login',   to:'sessions#new'
  post  '/login',   to:'sessions#create'
  delete'/logout',  to:'sessions#destroy'
  
  
  resources :users
  # いわゆる/users/:id　でどんな番号のURLにも対応できるようにしてる。（Progateのユーザーのルーティングと同じ）
  
  resources :account_activations, only: [:edit]
  # resouces（CRUDを含めた7種類）の中から、only以下だけを絞ってルーティングを作成してる。
end
