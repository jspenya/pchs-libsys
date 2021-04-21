class BooksController < ApplicationController
  # protect_from_forgery with: :null_session  # remove csrf authentication on http requests
  before_action :check_user, except: [:index, :stud_filter_book]
  require 'csv' 

  def check_user
    @user = current_user
    if @user.admin?
    else
      flash[:notice] = "You have no power!" 
      redirect_to root_path
    end
  end

  def index
    @user = current_user
    @books = Book.all
    # @books = @books.paginate(page: params[:page], per_page: 10)

    if params[:keyword].present?
			@books = @books.where('lower(isbn) LIKE :query OR lower(title) LIKE :query OR lower(author) LIKE :query', query: "%#{(params[:keyword]).downcase}%")
		end
  end

  def filter_book
		book_category = params[:subject_id]
		if book_category == "1"
			@books = Book.where(subject_id: 1)
		elsif book_category == "2"
			@books = Book.where(subject_id: 2)
    elsif book_category == "3"
			@books = Book.where(subject_id: 3)
    elsif book_category == "4"
			@books = Book.where(subject_id: 4)
    elsif book_category == "5"
			@books = Book.where(subject_id: 5)
		else
			@books = Book.all
		end

    respond_to do |format|
			format.html { }
			format.js { }
		end
	end

  def stud_filter_book
		book_category = params[:subject_id]
		if book_category == "1"
			@books = Book.where(subject_id: 1)
		elsif book_category == "2"
			@books = Book.where(subject_id: 2)
    elsif book_category == "3"
			@books = Book.where(subject_id: 3)
    elsif book_category == "4"
			@books = Book.where(subject_id: 4)
    elsif book_category == "5"
			@books = Book.where(subject_id: 5)
		else
			@books = Book.all
		end

    respond_to do |format|
			format.html { }
			format.js { }
		end
	end

  def show
    @user = current_user
    @book = Book.find(params[:id])
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
    if @book.save
      redirect_to action: :show, id: @book
    else
      @subjects = Subject.all
      render :new
    end
  end

  def edit
    @user = current_user
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
    flash[:notice] = 'Book deleted successfully'
    redirect_to action: :index
  end

  def send_details
    # Active Job delivery methods  =>  deliver_later, deliver_now
    # Sidekiq delivery methods     =>  delay
    UsersMailer.send_book_details(params[:id], current_user.id).deliver_now
    redirect_to action: :index, notice: 'Book Details Sent!'
  end

  def show_subjects
    @user = current_user
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
