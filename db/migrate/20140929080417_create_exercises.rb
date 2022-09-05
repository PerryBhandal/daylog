class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.datetime :exercised_at
      t.string :type
      t.text :description
      t.text :comments

      t.timestamps
    end
  end
end
