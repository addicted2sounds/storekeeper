Rails.application.routes.draw do

  devise_for :users, controllers: {
      omniauth_callbacks: 'omniauth_callbacks'
  }
  root 'welcome#index'

  resources :products do
    patch 'retry', on: :member
    # get 'parsed', on: :collection
    collection do
      get 'parsed'
      post :add
    end
  end

end
