class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.belongs_to :source, index: true    #foreign key
      t.string  :asset_url, null: false
      t.string  :source_asset_id, null: false
      t.string  :address, null: false
      t.string  :city, null: false
      t.string  :state, {null: false, limit:2}
      t.integer :zip, null: false
      t.string  :img_thumbnail
      t.string  :img_large
      t.timestamp :listed_date
      t.timestamp :start_date, null: false
      t.timestamp :end_date
      t.decimal   :current_price, null: false
      t.boolean    :auction, null: false
      t.boolean   :internet_sale, null: false   #live_sale or internet_sale      
      t.boolean    :residential, default: 1    #residential or commercial
      t.string    :size, limit: 20
      t.integer   :year_built, limit:5
      t.timestamps null: false
    end
  end
end
