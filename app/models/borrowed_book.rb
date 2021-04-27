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

  def receipt
    Receipts::Receipt.new(
      id: id,
      subheading: "Hi #{student.firstname}! This is your receipt for Borrow Record ##{id}.",
      product: "this book",
      company: {
        name: "Pangantucan Community High School",
        address: "Overview Village, Poblacion\nPangantucan, Bukidnon ",
        email: "0917-811-0150",
        logo: Rails.root.join("app/assets/images/pchs.png")
      },
      line_items: [
        ["Date Borrowed",           created_at.strftime("%B %d, %Y at %l:%M:%S %p")],
        ["Borrower's Name", "#{student.fullname_norm} (#{student.lrn})"],
        ["Book Title",        book.title],
        ["ISBN",         book.isbn],
        ["Return before", due_date.strftime("%B %d, %Y at %l:%M:%S %p")]
      ],
    )
  end
end
