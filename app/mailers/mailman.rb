class Mailman < ActionMailer::Base
  default from: "scheduler@boilerinvasion.org"
	add_template_helper ApplicationHelper

	def enroll student
		@student = student
		mail :to => @student.email, :subject => "Robotics sign up confirmation"
	end
	
	def payment student
		@student = student
		mail :to => @student.email, :subject => "Robotics payment"
	end
end
