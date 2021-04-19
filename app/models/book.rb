# == Schema Information
#
# Table name: books
#
#  id              :bigint           not null, primary key
#  title           :string(32)       not null
#  price           :float
#  subject_id      :integer
#  description     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  image           :string
#  author          :string
#  isbn            :string
#  publisher       :string
#  borrow_duration :integer
#
class Book < ApplicationRecord
  belongs_to :subject

  mount_uploader :image, ImageUploader

  validates_presence_of :title
  # validates_numericality_of :price, message: 'Price should be numeric'
  # validates :image, file_size: { less_than: 1.megabytes }

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Book.create! row.to_hash
    end
  end
end
