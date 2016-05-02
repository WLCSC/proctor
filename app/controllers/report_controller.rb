class ReportController < ApplicationController
    skip_before_filter :check_for_user, :only => :index
    def index
        @exams = Exam.order("date ASC, session ASC").all
        @locked = self_locked?
    end

    def tickets
        @students = params[:student_ids] ? Student.where(:id => params[:student_ids]) : Student.all.delete_if{|s| s.exams.length == 0}.sort{|a,b| a.name <=> b.name}
        @top = params[:top] || nil
        @bottom = params[:bottom] || nil
    end

    def supervisors
        @supervisors = Supervisor.order(:name)
        @top = params[:top] || nil
        @bottom = params[:bottom] || nil
    end

    def attendance
        @exams = Exam.order("date ASC, session ASC").all.delete_if{|x| x.students.length == 0}.sort{|a,b| [a.date, a.session] <=> [a.date, a.session]}
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
        @exams = Exam.order("date ASC, session ASC").all.sort{|a,b| [a.date, a.session] <=> [b.date, b.session]}
        @top = params[:top] || nil
        @bottom = params[:bottom] || nil
        @checks = params[:checks] || nil
        @limits = params[:limits] || nil
    end

    def lock
        if params[:commit] == "Lock Self Enrollment Section"
            self_lock
        end

        if params[:commit] == "Unlock Self Enrollment Section"
            self_unlock
        end

        @locked = self_locked?
    end

    def reset
        if params[:commit] == "Wipe all students"
            Student.all.each do |s|
                s.delete
            end

            Enrollment.all.each do |e|
                e.delete
            end

            redirect_to root_path, :notice => "Wiped students"
        end
        if params[:commit] == "Wipe all exams"
            Exam.all.each do |e|
                e.delete
            end

            Enrollment.all.each do |e|
                e.delete
            end

            redirect_to root_path, :notice => "Wiped exams"
        end

    end
end
