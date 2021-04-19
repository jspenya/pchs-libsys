class BookController < ApplicationController
  # protect_from_forgery with: :null_session  # remove csrf authentication on http requests
  require 'csv' 

  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new
    @subjects = Subject.all
  end

  def import
    Book.import(params[:file])
    redirect_to book_index_path, notice: "Books added successfully!"
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to action: :show, id: @book
    else
      @subjects = Subject.all
      render :new
    end
  end

  def edit
    @book = Book.find(params[:id])
    @subjects = Subject.all
  end

  def update
    @book = Book.find(params[:id])
    if @book.update_attributes(book_param)
      redirect_to action: :show, id: @book
    else
      @subjects = Subject.all
      render :edit
    end
  end

  def delete
    Book.find(params[:id]).destroy
    redirect_to action: :index
  end

  def send_details
    # Active Job delivery methods  =>  deliver_later, deliver_now
    # Sidekiq delivery methods     =>  delay
    UsersMailer.send_book_details(params[:id], current_user.id).deliver_now
    redirect_to action: :index, notice: 'Book Details Sent!'
  end

  def show_subjects
    @subject = Subject.find(params[:id])
  end

  private
  # create - permit params
  def book_params
    params.require(:book).permit(:title, :author, :subject_id, :description, :image)
  end
   # update - permit params
   def book_param
    params.require(:book).permit(:title, :author, :price, :subject_id, :description, :image, :image_cache)
  end

end
