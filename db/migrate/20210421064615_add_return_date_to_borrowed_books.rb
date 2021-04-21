class AddReturnDateToBorrowedBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :borrowed_books, :return_date, :datetime
    add_column :borrowed_books, :due_date, :datetime
  end
end
