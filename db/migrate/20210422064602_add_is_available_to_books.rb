class AddIsAvailableToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :is_available, :boolean, :default => true
  end
end
