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
#  is_available    :boolean          default(TRUE)
#  shelf_number    :string
#
class Book < ApplicationRecord
  searchkick
  belongs_to :subject
  has_many :borrowed_books
  has_many :students, :through => :borrowed_books
  has_many :likes
  has_many :users, through: :likes

  has_many :comments, as: :commentable
  mount_uploader :image, ImageUploader

  validates_presence_of :title

  scope :borrowed, ->{where( id: BorrowedBook.not_returned.pluck(:book_id))}
  
  scope :not_borrowed, ->{ Book.all.where.not(id: Book.borrowed)}
  
  scope :returned, ->{where( id: BorrowedBook.returned.pluck(:book_id))}
  # Ex:- scope :active, -> {where(:active => true)}

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Book.create! row.to_hash
    end
  end
  
  def isbn_and_title
    @isbn_and_title ||= "#{isbn} #{title}"
  end
end
