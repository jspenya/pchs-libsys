class Books::LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book

  def create
    @book.likes.where(user_id: current_user.id).first_or_create!

    respond_to do |format|
      format.html { redirect_to @book }
      format.js {  }
    end
  end

  def destroy
    @book.likes.where(user_id: current_user.id).destroy_all

    respond_to do |format|
      format.html { redirect_to @book }
      format.js {  }
    end
  end

  private
  def set_book
    @book = Book.find(params[:book_id])
  end
end
