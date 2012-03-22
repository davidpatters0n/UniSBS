class Soa::BookingsController < Soa::SoaController

  # POST /soa/booking/confirm
  # params[:booking][:reference_number]   #string
  # params[:booking][:tms]       #string
  # params[:booking][:site]               #string
  # params[:booking][:confirmation_time]   #datetime
  # params[:booking][:number_of_pallets]  #integer
  def confirm

    begin
      raise 'booking information missing' if params[:booking].nil?
      company_id = Company.find_by_tms(
                         params[:booking][:tms])

      raise 'haulier code not found' if company_id.nil?
    
      booking = Booking.find_or_initialise_by_reference_number_and_company_id(
                     params[:booking][:reference_number],
                     company_id)

      raise 'could not find or initialise booking' if booking.nil?

      booking.site = params[:booking][:site]
      bookings.confirmation_time = params[:booking][:appointment_time]
      bookigns.number_of_pallets = params[:booking][:number_of_pallets]
      booking.check_confirmed_diary_time!
      booking.update_slot!
      booking.save!

      status = 202
      text = 'booking confirmed'
    rescue Exception => exc
      status = 406
      text = esc.message
    end

    respond_to do |format|
      format.html { render :text => text, :status => status }
    end
  end

end
