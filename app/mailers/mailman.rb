class Mailman < ActionMailer::Base
  include Resque::Mailer
  default from: "noreply@wl.k12.in.us"
	add_template_helper ApplicationHelper

	def enroll student
		@student = Student.find(student)
		if @student && @student.email
		mail :to => @student.email.strip, :subject => "Sign up confirmation"
		end
	end
	
	def payment student
		@student = student.find(student)
		if @student && @student.email
		mail :to => @student.email.strip, :subject => "Payment information"
		end
	end
end
