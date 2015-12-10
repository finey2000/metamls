class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :slug, {null: false, limit: 30}
      t.string :url, null: false
      t.string :type, {null: false, limit: 10}     
      t.string :listing_type, {null:  false, limit: 15}
      t.boolean :active, default: 1
      t.integer :update_frequency, default: 24
      t.text   :note            
      t.timestamps null: false
    end
    add_index :sources, :slug, unique: true
  end
end
