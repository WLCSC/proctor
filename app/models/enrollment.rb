class ConflictValidator < ActiveModel::Validator
	def validate(record)
		if record.exam.limit != 0 && record.exam.enrollments.count >= record.exam.limit
			record.errors[:base] << "The exam is full."
		end
		if Enrollment.where(:student_id => record.student, :exam_id => record.exam).length > 0
			record.errors[:base] << "The student is already enrolled in this exam."
		elsif !record.alternate && Enrollment.where(:student_id => record.student).where(:alternate => false).where(:exam_id => Exam.where(:session => record.exam.session, :date => record.exam.date).map{|e| e.id}).length > 0
			record.errors[:base] << "Students can't take multiple exams at the same time."
		end
	end
end

class Enrollment < ActiveRecord::Base
	belongs_to :student
	belongs_to :exam

	validates_associated :student
	validates_associated :exam

	after_save :charge_student
	before_destroy :refund_student

	validates_with ConflictValidator

	def charge_student
		t = (exam.cost < 0) ? 'credit' : 'exam'
		student.charge 0, (discount ? exam.discount : exam.cost) * -1, "Enrolled in #{exam.name}", t if exam.cost != 0
	end

	def refund_student
		t = (exam.cost < 0) ? 'exam' : 'credit'
		student.charge 0, (discount ? exam.discount : exam.cost ), "Unenrolled from #{exam.name}", t if exam.cost != 0
	end
end
