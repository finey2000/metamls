class ModifySourceType < ActiveRecord::Migration
  def change
    rename_column :sources, :type, :source_type    
  end
end
