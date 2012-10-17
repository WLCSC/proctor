class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.decimal :change, :precision => 6, :scale => 2
      t.string :comment
      t.integer :user_id
      t.integer :student_id

      t.timestamps
    end
  end
end
