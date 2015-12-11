class AddScraperClassToSource < ActiveRecord::Migration
  def change
    add_column :sources, :scraper_class, :string, null: false, limit: 40
  end
end
