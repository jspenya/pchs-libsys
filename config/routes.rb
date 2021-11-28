Rails.application.routes.draw do
  resources :students do
    collection { post :import }
    resources :comments, module: :students
  end
  devise_for :users

  root :to => "books#index"

  resources :books, except: :destroy do
    resource :like, module: :books
    resources :comments, module: :books

    get :send_details, on: :member
    get :delete, on: :member
    get :show_subjects, on: :collection
    get :autocomplete_book, :on => :collection
    collection { post :import }
  end
  
  resources :subjects do
    get :delete, on: :member
  end

  resources :borrowed_books do
    get :autocomplete_book, :on => :collection
  end

	get '/filter_book', to: "books#filter_book", as: "filter_book"
	get '/filter_books', to: "borrowed_books#filter_books", as: "filter_books"
	get '/stud_filter_book', to: "books#stud_filter_book", as: "stud_filter_book"
	get '/borrowed_books/:id/return_book', to: "borrowed_books#return_book", as: "return_book"

end
