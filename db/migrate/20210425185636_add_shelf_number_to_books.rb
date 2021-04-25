class AddShelfNumberToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :shelf_number, :string
  end
end
