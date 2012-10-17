class Student < ActiveRecord::Base
	has_many :enrollments, :dependent => :destroy
	has_many :exams, :through => :enrollments
	has_many :payments, :dependent => :destroy

	after_create :default_charge

	def charge(user_id,change,comment,type)
		self.balance ||= 0
		self.save
		payments.create(:user_id => user_id, :change => change, :comment => comment, :kind => type)
	end

	def default_charge
		charge(0,self.balance,"Initial Balance",'other')
	end

	def proper
		q = name.split ' '
		last = q.delete_at(0)
		(q.join " ") + ', ' + last
	end
end
