class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|
      t.integer :exam_id
      t.integer :student_id
      t.string :comment

      t.timestamps
    end
  end
end
