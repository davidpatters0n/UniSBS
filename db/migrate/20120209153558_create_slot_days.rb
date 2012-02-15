class CreateSlotDays < ActiveRecord::Migration
 def change
    create_table :slot_days do |t|
      t.date :day
      t.integer :site_id

      t.timestamps
    end
  end
end
