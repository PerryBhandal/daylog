class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :title
      t.text :content
      t.datetime :last_viewed
      t.integer :total_views
      t.integer :note_category_id

      t.timestamps
    end

    NoteCategory.create(:name => "uncategorized")
  end
end
