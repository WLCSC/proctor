class Mailman < ActionMailer::Base
  default from: "scheduler@boilerinvasion.org"
	add_template_helper ApplicationHelper

	def enroll student
		@student = student
		if @student.email
		mail :to => @student.email, :subject => "AP enrollment confirmation"
		end
	end
	
	def payment student
		@student = student
		if @student.email
		mail :to => @student.email, :subject => "AP test payment posted"
		end
	end
end
