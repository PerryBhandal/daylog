class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.datetime :eaten_at
      t.integer :meal_quality
      t.text :meal_contents
      t.text :comments

      t.timestamps
    end
  end
end
