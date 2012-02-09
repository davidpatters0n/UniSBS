class CreateSlotday < ActiveRecord::Migration
 def change
    create_table :slot_day do |t|
      t.datetime :day
      t.integer :capacity

      t.timestamps
    end
  end
end
