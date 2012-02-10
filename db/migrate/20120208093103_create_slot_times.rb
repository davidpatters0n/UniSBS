class CreateSlotTimes < ActiveRecord::Migration
  def change
    create_table :slot_times do |t|
      t.integer :slot_day_id
      t.datetime :time_slot
      t.integer :capacity

      t.timestamps
    end
  end
end
