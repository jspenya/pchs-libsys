# == Schema Information
#
# Table name: subjects
#
#  id   :bigint           not null, primary key
#  name :string
#
class Subject < ApplicationRecord
  has_many :books, dependent: :destroy
end
