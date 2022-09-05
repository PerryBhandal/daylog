class CreateActiveTasks < ActiveRecord::Migration
  def change
    create_table :active_tasks do |t|
      t.string :task_name
      t.datetime :start_time

      t.timestamps
    end
  end
end
