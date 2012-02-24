class CreateSiteLogentries < ActiveRecord::Migration
  def change
    create_table :site_logentries do |t|
      t.integer  :site_id
      t.string   :company
      t.string   :booking
      t.string   :name
      t.integer :past_days_to_keep
      t.integer :days_in_advance
      t.integer :provisional_bookings_expire_after
      t.integer :granularity_id

      t.timestamps
    end
  end
end
