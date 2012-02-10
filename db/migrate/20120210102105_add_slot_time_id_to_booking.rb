class AddSlotTimeIdToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :slot_time_id, :integer
  end
end
