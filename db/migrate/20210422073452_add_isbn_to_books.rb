class AddIsbnToBooks < ActiveRecord::Migration[5.2]
  def change
    add_index :books, :isbn
  end
end
