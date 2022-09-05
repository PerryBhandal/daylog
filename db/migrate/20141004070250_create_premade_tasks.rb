class CreatePremadeTasks < ActiveRecord::Migration
  def change
    create_table :premade_tasks do |t|
      t.string :name

      t.timestamps
    end
  end
end
