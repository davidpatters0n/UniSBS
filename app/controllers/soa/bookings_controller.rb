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

      # default response
      text = 'booking confirmed'
      
      # find company by TMS parameter
      tms = params[:booking][:tms]
      company = Company.find_by_tms(tms) unless tms.nil?

      # fall back to 'UNKNOWN' TMS if no company found
      if company.nil?
        text << "; unexpected haulier code '#{tms}'"
        company = Company.find_by_tms('UNKNOWN')
      end

      # Create/Update booking
      booking = Booking.find_or_initialize_by_reference_number_and_company_id(
                     params[:booking][:reference_number],
                     company.id)

      booking.confirmed_appointment = params[:booking][:appointment_time]
      if booking.confirmed_appointment.nil?
        text << "; no confirmed appointment time"
      end

      site = Site.find_by_name(params[:booking][:site])
      if site.nil?
        text << "; unknown site '#{params[:booking][:site]}'"
      else
      # TODO find slot_time for given site and appointment time (provisional and confirmed)
      # Determine which slot_time to stuff ourselves into
      end
      
      booking.pallets_expected = params[:booking][:number_of_pallets]
      
      booking.save!

      status = 200
    rescue Exception => e
      status = 406
      text = e.message
    end

    respond_to do |format|
      format.html { render :text => text, :status => status }
    end
  end

end
