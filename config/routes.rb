Rails.application.routes.draw do

  devise_for :users
  root 'welcome#index'

  resources :products do
    get 'parsed', on: :collection
    collection do
      post :add
    end
  end

end
