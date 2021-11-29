# == Schema Information
#
# Table name: subjects
#
#  id   :bigint           not null, primary key
#  name :string
#
class Subject < ApplicationRecord
  has_many :books, dependent: :destroy

  def self.search_keyword(keyword)
    where('lower(name) LIKE :query', query: "%#{(keyword).downcase}%")
  end
end
