class BooksController < ApplicationController
  before_action :set_book, only: [:show, :destroy, :edit, :update]
  autocomplete :book, :isbn
  require 'csv'

  def index
    @user = current_user
    @books = Book.all.order('created_at DESC')
    @subjects = Subject.all

    if params[:keyword].present?
			@books = @books.search_keyword(params[:keyword])
		end

    if params[:subject].present?
      @books = @books.search_subject(params[:subject])
    end

    respond_to do |format|
      format.html { }
      format.js {  }
    end
  end

  def show
    @user = current_user
    @book = @book
  end

  def new
    @user = current_user
    @book = Book.new
    @subjects = Subject.all
  end

  def import
    Book.import(params[:file])
    redirect_to books_path, notice: "Books added successfully!"
  end

  def create
    @book = Book.new(book_params)
    @book.update(borrow_duration: 56)
    
    if @book.save
      flash[:notice] = "Book added successfully!"
      redirect_to action: :new
    else
      @subjects = Subject.all
      flash[:error] = "Book not saved!"
      render :new
    end
  end

  def edit
    @user = current_user
    @subjects = Subject.all
  end

  def update
    if @book.update_attributes(book_params)
      flash[:notice] = "Successfully updated book!"
      redirect_to action: :show, id: @book
    else
      flash[:error] = "Error updating book."
      @subjects = Subject.all
      render :edit
    end
  end

  def destroy
    @book.destroy
    flash[:notice] = 'Book deleted successfully'
    redirect_to action: :index
  end

  def show_subjects
    @subject = Subject.find(params[:id])
  end

  private
  def set_book
    @book = Book.find(params[:id])
  end
  
  def book_params
    params.require(:book).permit(:title, :author, :subject_id, :description, :image, :isbn, :publisher, :book_duration, :shelf_number)
  end
end
