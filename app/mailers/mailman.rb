class Mailman < ActionMailer::Base
  default from: "scheduler@wl.k12.in.us"
	add_template_helper ApplicationHelper

	def enroll student
		@student = student
		if @student.email
		mail :to => @student.email.strip, :subject => "Robotics sign up confirmation"
		end
	end
	
	def payment student
		@student = student
		if @student.email
		mail :to => @student.email.strip, :subject => "Robotics payment"
		end
	end
end
