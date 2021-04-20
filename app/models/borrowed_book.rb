# == Schema Information
#
# Table name: borrowed_books
#
#  id         :bigint           not null, primary key
#  book_id    :integer
#  student_id :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class BorrowedBook < ApplicationRecord
  belongs_to :student
  belongs_to :book
end
