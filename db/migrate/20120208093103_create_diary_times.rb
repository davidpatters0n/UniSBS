class CreateDiaryTimes < ActiveRecord::Migration
  def change
    create_table :diary_times do |t|
      t.integer :diary_day_id
      t.integer :minute_of_day
      t.integer :capacity

      t.timestamps
    end
  end
end
