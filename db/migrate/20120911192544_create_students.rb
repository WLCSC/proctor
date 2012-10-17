class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
      t.decimal :balance, :precision => 6, :scale => 2

      t.timestamps
    end
  end
end
