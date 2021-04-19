# == Schema Information
#
# Table name: students
#
#  id         :bigint           not null, primary key
#  lrn        :string
#  firstname  :string
#  lastname   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Student < ApplicationRecord
  has_many :borrowed_books
  has_many :books, :through => :borrowed_books
end
