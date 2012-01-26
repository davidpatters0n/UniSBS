class CreateAdminLevels < ActiveRecord::Migration
  def change
    create_table :admin_levels do |t|
      t.string :name

      t.timestamps
    end
    
    add_column :users, :admin_level_id, :integer
  
  end
end
