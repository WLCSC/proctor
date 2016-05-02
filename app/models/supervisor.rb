class Supervisor < ActiveRecord::Base
  attr_accessible :name
  has_many :exams
end
