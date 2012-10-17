class AddRepeatToEnrollment < ActiveRecord::Migration
  def change
    add_column :enrollments, :repeated, :boolean

  end
end
