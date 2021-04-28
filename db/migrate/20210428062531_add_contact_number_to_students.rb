class AddContactNumberToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :contact_number, :string
  end
end
