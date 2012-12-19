class AddFrlToStudents < ActiveRecord::Migration
  def change
    add_column :students, :frl, :boolean

  end
end
