class ChangeImageUrlColumn < ActiveRecord::Migration[5.2]
  def change
    rename_column :books, :image_url, :thumbnail_image_url
  end
end
