class PropertyStatus < ActiveRecord::Migration
  def change
    add_column :properties,:status, :boolean, default: 1
  end
end
