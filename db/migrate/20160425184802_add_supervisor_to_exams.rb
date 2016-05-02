class AddSupervisorToExams < ActiveRecord::Migration
  def change
    add_column :exams, :supervisor_id, :integer
    add_column :exams, :supervisor_information, :text
  end
end
