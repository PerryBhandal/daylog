class ChangeExerciseTypeColumnToExerciseType < ActiveRecord::Migration
  def change
    rename_column :exercises, :type, :exercise_type
  end
end
