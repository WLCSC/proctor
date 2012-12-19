class AddSelfToExam < ActiveRecord::Migration
  def change
    add_column :exams, :self_enrollable, :boolean

  end
end
