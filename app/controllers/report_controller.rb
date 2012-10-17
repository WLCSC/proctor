class ReportController < ApplicationController
	skip_before_filter :check_for_user, :only => :index
  def index
  end

  def tickets
	@students = params[:student_ids] ? Student.where(:id => params[:student_ids]) : Student.all.delete_if{|s| s.exams.length == 0}.sort{|a,b| a.proper <=> b.proper}
	@top = params[:top] || nil
	@bottom = params[:bottom] || nil
  end

  def attendance
	@exams = Exam.all.delete_if{|x| x.students.length == 0}.sort{|a,b| [a.date, a.session] <=> [a.date, a.session]}
	@top = params[:top] || nil
	@bottom = params[:bottom] || nil
  end

  def unpaid
	@students = params[:student_ids] ? Student.where(:id => params[:student_ids]) : Student.where('balance < 0').delete_if{|s| s.exams.length == 0}.sort{|a,b| a.proper <=> b.proper}
	@top = params[:top] || nil
	@bottom = params[:bottom] || nil
	@keys = params[:keys] || nil
  end

  def exams
	@exams = Exam.all.sort{|a,b| [a.date, a.session] <=> [b.date, b.session]}
	@top = params[:top] || nil
	@bottom = params[:bottom] || nil
	@checks = params[:checks] || nil
	@limits = params[:limits] || nil
  end
end
