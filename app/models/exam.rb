class Exam < ActiveRecord::Base
	has_many :enrollments, :dependent => :destroy
	has_many :students, :through => :enrollments
    belongs_to :supervisor

	validates :name, :presence => true
	validates :date, :presence => true
	validates :session, :presence => true
	validates :cost, :presence => true
	validates :discount, :presence => true
end
