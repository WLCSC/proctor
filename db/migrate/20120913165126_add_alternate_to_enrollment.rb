class AddAlternateToEnrollment < ActiveRecord::Migration
  def change
    add_column :enrollments, :alternate, :boolean

  end
end
