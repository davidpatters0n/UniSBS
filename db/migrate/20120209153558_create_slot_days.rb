class CreateSlotDays < ActiveRecord::Migration
 def change
    create_table :slot_days do |t|
      t.datetime :day
      t.integer :site_id

      t.timestamps
    end
  end
end
