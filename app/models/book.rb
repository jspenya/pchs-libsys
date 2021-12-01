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
  self.per_page = 10
  searchkick text_start: [:title], suggest: [:title]
  belongs_to :subject
  validates_presence_of :title
  has_many :borrowed_books, dependent: :destroy
  has_many :students, :through => :borrowed_books
  has_many :likes, dependent: :destroy
  has_many :users, through: :likes
  has_many :comments, as: :commentable
  mount_uploader :image, ImageUploader

  scope :borrowed, ->{where( id: BorrowedBook.not_returned.pluck(:book_id))}
  scope :not_borrowed, ->{ Book.all.where.not(id: Book.borrowed)}
  scope :returned, ->{where( id: BorrowedBook.returned.pluck(:book_id))}

  def search_data
    {
      title: title,
      subject: subject
    }
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Book.create! row.to_hash
    end
  end
  
  def isbn_and_title
    @isbn_and_title ||= "#{isbn} #{title}"
  end

  def self.search_keyword(keyword)
    where('lower(isbn) ILIKE :query OR lower(title) ILIKE :query OR lower(author) ILIKE :query', query: "%#{keyword}%")
  end

  def self.search_subject(subject)
    where('subject_id = :query', query: "#{subject}")
  end
end
