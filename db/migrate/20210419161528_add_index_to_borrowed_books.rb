class AddIndexToBorrowedBooks < ActiveRecord::Migration[5.2]
  def change
    add_index :borrowed_books, :book_id
    add_index :borrowed_books, :student_id
    add_index :borrowed_books, :user_id
  end
end
