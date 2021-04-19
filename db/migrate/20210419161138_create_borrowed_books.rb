class CreateBorrowedBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :borrowed_books do |t|
      t.integer :book_id
      t.integer :student_id
      t.integer :user_id

      t.timestamps
    end
  end
end
