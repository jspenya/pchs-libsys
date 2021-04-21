class BorrowedBooksController < ApplicationController
  def index
    @user = current_user
    @borrowed_books = BorrowedBook.all
  end

  def new
    @user = current_user
    @borrowed_book = BorrowedBook.new
    @available_books = Book.not_borrowed
    @students = Student.all
  end

  def return_book
    @borrowed_book = BorrowedBook.find(params[:id])
    if @borrowed_book.update(return_date: DateTime.now)
      flash[:notice] = 'Book is returned sucessfully!'
      redirect_to borrowed_book_path(@borrowed_book.id)
    else
      flash[:error] = 'There seems to be an error in returning book.'
      redirect_to borrowed_book_path(@borrowed_book.id)
    end
  end

  def show
    @user = current_user
    @borrowed_book = BorrowedBook.find(params[:id])
    @due = @borrowed_book.created_at + (@borrowed_book.book.borrow_duration).day
  end

  def create
    @borrowed_book = BorrowedBook.new(borrowed_book_params)

    respond_to do |format|
      if @borrowed_book.save
        format.html { redirect_to @borrowed_books, notice: "Record successfully created." }
        format.json { render :index, status: :created, location: @borrowed_books }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @borrowed_book.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_borrowed_book
    @borrowed_book = BorrowedBook.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def borrowed_book_params
    params.require(:borrowed_book).permit(:student_id, :book_id, :user_id, :due_date)
  end
end
