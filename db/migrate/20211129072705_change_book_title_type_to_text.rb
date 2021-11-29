class ChangeBookTitleTypeToText < ActiveRecord::Migration[5.2]
  def change
    remove_column :books, :title, :string

    add_column :books, :title, :text
  end
end
