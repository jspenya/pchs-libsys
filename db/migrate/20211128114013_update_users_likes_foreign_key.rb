class UpdateUsersLikesForeignKey < ActiveRecord::Migration[5.2]
  def change
    # remove old foreign key
    remove_foreign_key :likes, :users
    
    # add new foreign key
    add_foreign_key :likes, :users, on_delete: :cascade
  end
end
