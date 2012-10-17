class Payment < ActiveRecord::Base
	belongs_to :user
	belongs_to :student
	attr_accessible :kind, :change, :user_id, :comment, :student_id

	validates :change, :presence => true
	validates :comment, :presence => true
	validates_associated :student
	validates :kind, :presence => true

	after_save :charge_balance

	def charge_balance
		student.balance += change
		student.save
	end

	def user
		if user_id == 0
			User.new(:username => "system", :name => "System")
		else
			User.find(user_id)
		end
	end

	def type
		kind
	end
end
