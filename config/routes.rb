Rails.application.routes.draw do
  resources :students
  devise_for :users

  root :to => "books#index"

  resources :books, except: :destroy do
    get :send_details, on: :member
    get :delete, on: :member
    get :show_subjects, on: :collection
    collection { post :import }
  end

  devise_scope :user do
    # root to: "devise/sessions#new"
  end

	get '/filter_book', to: "books#filter_book", as: "filter_book"

end
