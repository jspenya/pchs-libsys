Rails.application.routes.draw do
  resources :students do
    collection { post :import }
  end
  devise_for :users

  root :to => "books#index"

  resources :books, except: :destroy do
    get :send_details, on: :member
    get :delete, on: :member
    get :show_subjects, on: :collection
    # get :autocomplete_book_isbn, :on => :collection
    get :autocomplete_book, :on => :collection
    collection { post :import }
  end
  
  resources :subjects

  resources :borrowed_books do
    get :autocomplete_book, :on => :collection
  end

  devise_scope :user do
    # root to: "devise/sessions#new"
  end

	get '/filter_book', to: "books#filter_book", as: "filter_book"
	get '/stud_filter_book', to: "books#stud_filter_book", as: "stud_filter_book"
	get '/borrowed_books/:id/return_book', to: "borrowed_books#return_book", as: "return_book"

end
