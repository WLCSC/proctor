class AddDiscountToEnrollment < ActiveRecord::Migration
  def change
    add_column :enrollments, :discount, :boolean

  end
end
