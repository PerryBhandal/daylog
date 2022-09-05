class CreateNoteCategories < ActiveRecord::Migration
  def change
    create_table :note_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
