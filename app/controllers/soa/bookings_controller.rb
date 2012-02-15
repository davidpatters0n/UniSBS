class Soa::BookingsController < Soa::SoaController

  # POST /soa/booking/confirm
  # params[:booking][:reference_number]   #string
  # params[:booking][:haulier_code]       #string
  # params[:booking][:site]               #string
  # params[:booking][:confirmation_time]   #datetime
  # params[:booking][:number_of_pallets]  #integer
  def confirm


    begin
      # default response
      text = 'booking confirmed'

      raise 'booking information missing' if params[:booking].nil?

      haulier_code = params[:booking][:haulier_code]
      if haulier_code.nil? or haulier_code.empty?
        haulier_code = "Unknown!"
      end
      
      company = Company.find_by_haulier_code(haulier_code)
      if company.nil?
        text << "; unexpected haulier code '#{haulier_code}'"
        company = Company.create(:name => "#{haulier_code}!!", :haulier_code => haulier_code)
      end
      raise "Cannot find or create company for haulier code '#{haulier_code}'" if company.nil?
    
      booking = Booking.find_or_initialize_by_reference_number_and_company_id(
                     params[:booking][:reference_number],
                     company.id)

      raise 'could not find or initialise booking' if booking.nil?

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

      status = 202
    rescue Exception => e
      status = 406
      text = e.message
    end

    respond_to do |format|
      format.html { render :text => text, :status => status }
    end
  end

end
