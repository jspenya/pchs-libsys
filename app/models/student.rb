# == Schema Information
#
# Table name: students
#
#  id             :bigint           not null, primary key
#  lrn            :string
#  firstname      :string
#  lastname       :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  contact_number :string
#
class Student < ApplicationRecord
  has_many :borrowed_books
  has_many :books, :through => :borrowed_books

  has_many :comments, as: :commentable

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Student.create! row.to_hash
    end
  end

  def fullname
    "#{lrn} - #{lastname}, #{firstname}"
  end

  def fullname_norm
    "#{firstname} #{lastname}"
  end
end
