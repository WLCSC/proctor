class AddDiscountToExams < ActiveRecord::Migration
  def change
    add_column :exams, :discount, :decimal, :precision => 6, :scale => 2

  end
end
