class AddDoubleDeckerToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :double_decker, :boolean
  end
end
