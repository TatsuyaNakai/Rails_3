Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  root  'static_pages#home'
  # rootは一番初めに立ち上げた時に開くページを指定する。
  get   '/help',    to:'static_pages#help'
  get   '/about',   to:'static_pages#about'
  get   '/contact', to:'static_pages#contact'
  
  get   '/signup',  to:'users#new'
  
  get   '/login',   to:'sessions#new'
  post  '/login',   to:'sessions#create'
  delete'/logout',  to:'sessions#destroy'
  resources :users do
    member do
      get :following, :followers
    end
  end
  # 基本的なルーティングがresourcesに入ってる。rails routesで確認できる。
  # memberメソッドやと、idが含まれるURLを扱うようになるけど、idを指定しない場合は、collectionメソッドを使う。
  
  resources :account_activations, only: [:edit]
  # resouces（CRUDを含めた7種類）の中から、only以下だけを絞ってルーティングを作成してる。
  
  resources :password_resets, only: [:new, :create, :edit, :update]
  
  resources :microposts, only: [:create, :destroy]
  
  resources :relationships, only: [:create, :destroy]
  
end
