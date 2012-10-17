class CreateExams < ActiveRecord::Migration
  def change
    create_table :exams do |t|
      t.string :name
      t.date :date
      t.integer :session
      t.decimal :cost, :precision => 6, :scale => 2
      t.text :description
      t.boolean :real

      t.timestamps
    end
  end
end
