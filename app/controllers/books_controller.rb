class BooksController < ApplicationController
  require 'csv'
  autocomplete :book, :isbn

  def index
    @user = current_user
    @books = Book.all.order('created_at DESC')
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

  def show_subjects
    @user = current_user
    @subject = Subject.find(params[:id])
  end

  private
  # create - permit params
  def book_params
    params.require(:book).permit(:title, :author, :subject_id, :description, :image, :isbn, :publisher, :book_duration, :shelf_number)
  end
end
