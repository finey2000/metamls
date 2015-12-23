class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.belongs_to :user, index: true    #foreign key
      t.belongs_to :property, index: true #foreign key
      t.boolean :alert, default: 0
      t.integer :rating, {limit: 1, default: 0}
      t.text :note
      t.timestamp :note_updated
      t.timestamps null: false
    end
  end
end
