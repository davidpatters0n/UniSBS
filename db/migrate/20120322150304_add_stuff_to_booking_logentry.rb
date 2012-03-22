class AddStuffToBookingLogentry < ActiveRecord::Migration
  def change
    add_column :booking_logentries, :live, :boolean
    add_column :booking_logentries, :double_decker, :boolean
    add_column :booking_logentries, :comment, :string
    add_column :booking_logentries, :status, :string
  end
end
