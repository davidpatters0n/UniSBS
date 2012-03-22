class AddMovedToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :moved, :boolean
  end
end
