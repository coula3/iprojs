class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :user_id
      t.string :title
      t.string :domain
      t.string :classification
      t.string :nature
      t.string :languages
      t.text :libraries
      t.string :phase
      t.text :notes
      t.datetime :start_date
      t.datetime :planned_end_date
      t.datetime :actual_end_date

      t.timestamps null: false
    end
  end
end
