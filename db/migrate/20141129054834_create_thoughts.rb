class CreateThoughts < ActiveRecord::Migration
  def change
    create_table :thoughts do |t|
      t.datetime :time_added
      t.text :thought

      t.timestamps
    end
  end
end
