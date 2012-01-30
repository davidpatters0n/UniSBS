class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.integer :company_id
      t.string :reference_number
      t.datetime :provisional_appointment
      t.datetime :confirmed_appointment
      t.integer :pallets_expected

      t.timestamps
    end
  end
end
