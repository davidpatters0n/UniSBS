class AddLiveAndCommentToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :live, :boolean
    add_column :bookings, :comment, :string
  end
end
