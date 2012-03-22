class CreateTemplateCapacities < ActiveRecord::Migration
  def change
    create_table :template_capacities do |t|
      t.integer :site_id
      t.integer :minutes
      t.integer :weekend_capacity
      t.integer :weekday_capacity

      t.timestamps
    end
  end
end
