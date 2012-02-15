class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.integer :past_days_to_keep
      t.integer :days_in_advance
      t.integer :provisional_bookings_expire_after
      t.integer :granularity_id

      t.timestamps
    end
  end
end
