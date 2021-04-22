class RemoveIsbnFromBooks < ActiveRecord::Migration[5.2]
  def change
    remove_index :books, :isbn
  end
end
