class AddLimitToExam < ActiveRecord::Migration
  def change
    add_column :exams, :limit, :integer
		Exam.all.each do |e|
			e.limit = 0
			e.save
		end	
  end
end
