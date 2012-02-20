class CreateBookingLogentries < ActiveRecord::Migration
  def change
    create_table :booking_logentries do |t|
      t.integer :booking_id
      t.string :site
      t.string :company
      t.string :reference_number
      t.datetime :provisional_appointment
      t.datetime :confirmed_appointment
      t.integer :pallets_expected

      t.timestamps
    end
  end
end
