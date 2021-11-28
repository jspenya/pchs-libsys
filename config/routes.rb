Rails.application.routes.draw do
  resources :students do
    collection { post :import }
    resources :comments, module: :students
  end
  devise_for :users

  root :to => "books#index"

  resources :books do
    resource :like, module: :books
    resources :comments, module: :books

    collection do
      get :show_subjects
      get :autocomplete_book
      post :import
    end
  end
  
  resources :subjects do
    get :delete, on: :member
  end

  resources :borrowed_books do
    get :autocomplete_book, on: :collection
    get :filter_books, on: :collection

    member do
      get :return_book
    end
  end
end
