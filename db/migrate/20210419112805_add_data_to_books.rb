class AddDataToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :isbn, :string
    add_index :books, :isbn, unique: true
    add_column :books, :publisher, :string
    add_column :books, :borrow_duration, :integer
  end
end
