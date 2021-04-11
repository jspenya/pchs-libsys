Rails.application.routes.draw do
  devise_for :users

  resources :book, except: :destroy do
    get :send_details, on: :member
    get :delete, on: :member
    get :show_subjects, on: :collection
    collection { post :import }
  end

  devise_scope :user do
    root to: "devise/sessions#new"
  end
end
