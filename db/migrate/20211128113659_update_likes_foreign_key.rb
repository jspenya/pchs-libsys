class UpdateLikesForeignKey < ActiveRecord::Migration[5.2]
  def change
    # remove old foreign key
    remove_foreign_key :likes, :books
    
    # add new foreign key
    add_foreign_key :likes, :books, on_delete: :cascade
  end
end
