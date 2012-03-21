class CreateDiaryDays < ActiveRecord::Migration
 def change
    create_table :diary_days do |t|
      t.date :day
      t.integer :site_id

      t.timestamps
    end
  end
end
