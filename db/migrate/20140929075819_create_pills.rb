class CreatePills < ActiveRecord::Migration
  def change
    create_table :pills do |t|
      t.datetime :consumed_at
      t.string :pill_name
      t.integer :quantity

      t.timestamps
    end
  end
end
