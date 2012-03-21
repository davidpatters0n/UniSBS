class AddDiaryTimeIdToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :diary_time_id, :integer
  end
end
