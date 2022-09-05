class CreateHygieneActions < ActiveRecord::Migration
  def change
    create_table :hygiene_actions do |t|
      t.datetime :action_time
      t.text :actions
      t.text :comments

      t.timestamps
    end
  end
end
