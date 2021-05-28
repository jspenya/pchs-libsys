class BooksController < ApplicationController
  # protect_from_forgery with: :null_session  # remove csrf authentication on http requests
  before_action :check_user, except: [:index, :show, :stud_filter_book, :send_details]
  require 'csv'

  autocomplete :book, :isbn

  def check_user
    @user = current_user
    if @user.admin?
    else
      flash[:notice] = "You have no power!" 
      redirect_to root_path
    end
  end

  def index
    Book.reindex
    @user = current_user
    @book = Book.new
    # @books = Book.all.order('created_at DESC')

    args = {}
      args[:isbn] = params[:isbn] if params[:isbn]
      args[:title] = params[:title] if params[:title]
      args[:author] = params[:author] if params[:author]
      
    @books = Book.search "*", where: args, aggs: {isbn: {}, title: {}, author: {}, availability: {}}
    @subjects = Subject.all

    if params[:keyword].present?
			@books = @books.where('lower(isbn) LIKE :query OR lower(title) LIKE :query OR lower(author) LIKE :query', query: "%#{(params[:keyword]).downcase}%")
		end

    if params[:subject].present?
      @books = @books.where('subject_id = :query', query: "#{(params[:subject])}")
    end

    if (term = params[:term]).present?
      terms = make_terms_from term
      @books = @books.where(terms)
    end

    respond_to do |format|
      format.html { }
      format.js {  }
    end
  end

  def autocomplete_book
    term = params[:term]
    terms = make_terms_from term
    @books = Book.not_borrowed.where(terms)
    render :json => @books.map { |book| {:id => book.id, :label => book.isbn_and_title, :value => book.isbn_and_title} }
  end
  
  def make_terms_from term
    terms = term.split.map{|t| "isbn ilike '%%%s%%'" % t}.join(" or ")    
  end

  def filter_book
    @books = Book.all.order('created_at DESC')

    respond_to do |format|
      format.html { }
      format.js { }
    end
  end

  def stud_filter_book
    @books = Book.all.order('created_at DESC')

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
    @book = Book.find(params[:id])
    @subjects = Subject.all
  end

  def update
    @book = Book.find(params[:id])
    if @book.update_attributes(book_param)
      redirect_to action: :show, id: @book
    else
      flash[:error] = "Error updating book."
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
    params.require(:book).permit(:title, :author, :subject_id, :description, :image, :isbn, :publisher, :book_duration, :shelf_number)
  end
   # update - permit params
   def book_param
    params.require(:book).permit(:title, :author, :price, :subject_id, :description, :image, :image_cache, :isbn, :publisher, :book_duration, :shelf_number)
  end

end
