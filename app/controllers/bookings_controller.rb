class BookingsController < PortalController

  # GET /bookings
  # GET /bookings.json
  def index

    session[:booking_context] = 'index'

    if current_user.is_booking_manager? 
      @bookings = Booking.all
    @main_heading = 'Bookings'
    else
      @bookings = current_user.company.bookings
    @main_heading = "#{current_user.company.name} Bookings"
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
    @booking = Booking.find(params[:id])
    @main_heading = 'View Booking'

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /bookings/1/edit
  def edit
    @booking = Booking.find(params[:id])
    @main_heading = 'Manually Edit Booking'
  end

  # Go to booking
  def goto_booking(booking)
    
    site = @booking.site
    slot_day = @booking.slot_day
    
    if session[:booking_context] and session[:booking_context] == 'diary' and site and slot_day
      
      # Go the diary page
      respond_to do |format|
        format.html { redirect_to diary_slot_day_path(site, slot_day) }
      end
    else

      # Go to booking page
      respond_to do |format|
        format.html { redirect_to booking_path(@booking) }
      end
    end
  end

  # POST /bookings
  # POST /bookings.json
  def create
    @booking = Booking.new(params[:booking])
    unless @booking and @booking.slot_time and @booking.slot_time.number_of_free_slots > 0
      flash[:notice] = 'Slot no longer available'
      redirect_to :back
      return
    end

    if @booking.save
      flash[:notice] = 'Booking was successfully created'
      goto_booking(@booking)
    else
      @main_heading = 'Review New Booking'
      respond_to do |format|
        format.html { render action: "new" }
      end
    end
  end

  # PUT /bookings/1
  # PUT /bookings/1.json
  def update
    @booking = Booking.find(params[:id])
    if @booking.update_attributes(params[:booking])
      flash[:notice] = 'Booking was successfully updated'
      goto_booking(@booking)
    else
      @main_heading = 'Review Booking'
      respond_to do |format|
        format.html { render action: "edit" }
      end
    end
  end

  def confirmation
    begin
      @booking = Booking.find(params[:booking][:id])
      @booking.update_attributes(params[:booking])
      if params[:make_unexpected]
        @booking.provisional_appointment = nil
        @booking.save!
      end
      @booking.update_slot!
      success = true
    rescue => e
      flash[:error] = e.message
      success = false
    end

    if success
      flash[:notice] = 'Booking confirmed'
      respond_to do |format|
        format.html { redirect_to booking_path(@booking) }
      end      
    else
      redirect_to :back
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    @booking = Booking.find(params[:id])

    if @booking
      if session[:booking_context] and session[:booking_context] == 'diary'
        site = @booking.site
        slot_day = @booking.slot_day
      end

      if @booking.destroy
        flash[:notice] = 'booking removed'
      else
        flash[:error] = 'could not remove booking'
      end
    end

    if site and slot_day
      
      # redirect to diary page
      respond_to do |format|
        format.html { redirect_to diary_slot_day_path(site, slot_day) }
      end
    else

      # redirect to booking index
      respond_to do |format|
        format.html { redirect_to bookings_url }
      end
    end
  end

end
