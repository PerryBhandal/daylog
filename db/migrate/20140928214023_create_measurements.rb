class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.date :date
      t.time :time
      t.float :weight
      t.float :waist_extended
      t.float :waist_normal
      t.float :hip
      t.float :chest
      t.float :bicep
      t.float :forearm
      t.float :calves
      t.float :thighs

      t.timestamps
    end
  end
end
