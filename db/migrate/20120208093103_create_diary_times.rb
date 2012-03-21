class CreateDiaryTimes < ActiveRecord::Migration
  def change
    create_table :diary_times do |t|
      t.integer :diary_day_id
      t.datetime :time_slot
      t.integer :capacity

      t.timestamps
    end
  end
end
