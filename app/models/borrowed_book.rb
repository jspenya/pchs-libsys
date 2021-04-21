# == Schema Information
#
# Table name: borrowed_books
#
#  id          :bigint           not null, primary key
#  book_id     :integer
#  student_id  :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  return_date :datetime
#  due_date    :datetime
#
class BorrowedBook < ApplicationRecord
  belongs_to :student
  belongs_to :book

  scope :not_returned, ->{ where( id: where(return_date:nil))}
  scope :returned, ->{ where( id: where.not(return_date:nil))}

  scope :overdue, -> { not_returned.where( "due_date < ?", Date.today ) }
end
