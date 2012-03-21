class BookingsController < PortalController

  def index
    session[:booking_context] = 'index'

    if current_user.is_booking_manager? 
    #  @bookings = Booking.all
    # @bookings = Booking.filter(params[:search], [:reference_number, :company_id])
     @bookings = Booking.includes(:company).filter(params[:search], [:reference_number, "companies.name"])
    @main_heading = 'Bookings'
    else
      @bookings = current_user.company.bookings
    @main_heading = "#{current_user.company.name} Bookings"
    end
  end

  # GET /bookings/1
  def show
    @booking = Booking.find(params[:id])
    goto_booking(@booking)
  end

  # Go to booking
  def goto_booking(booking)
    
    site = @booking.site
    diary_day = @booking.diary_day
    diary_time = @booking.diary_time
    
    # don't need to check diary_time because it is optional
    if session[:booking_context] and session[:booking_context] == 'diary' and site and diary_day
      # Go the diary page
      respond_to do |format|
        format.html { redirect_to diary_diary_day_time_path(site, diary_day, diary_time) }
      end
    else

      # Go to booking edit page
      respond_to do |format|
        format.html { redirect_to edit_booking_path(@booking) }
      end
    end
  end

  # POST /bookings
  def create
    @booking = Booking.new(params[:booking])
    unless @booking and @booking.diary_time and @booking.diary_time.number_of_free_slots >= @booking.slots_taken_up
      flash[:notice] = 'No longer enough slots available'
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

  def edit
    @booking = Booking.find(params[:id])
    @main_heading = 'Edit Booking'
  end
  
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

    respond_to do |format|
      format.html do
        if success
          flash[:notice] = 'Booking confirmed'
        else
          redirect_to :back
        end
        redirect_to booking_path(@booking)
      end
      format.js do
        # do the update here
        render 'update'
      end
    end
  end

  # DELETE /bookings/1
  def destroy
    @booking = Booking.find(params[:id])

    if @booking
      if session[:booking_context] and session[:booking_context] == 'diary'
        site = @booking.site
        diary_day = @booking.diary_day
        diary_time = @booking.diary_time
      end

      if @booking.destroy
        flash[:notice] = 'booking removed'
      else
        flash[:error] = 'could not remove booking'
      end
    end

    # don't need to check diary_time; that's optional
    if site and diary_day
      
      # redirect to diary page
      respond_to do |format|
        format.html { redirect_to diary_diary_day_time_path(site, diary_day, diary_time) }
      end
    else

      # redirect to booking index
      respond_to do |format|
        format.html { redirect_to bookings_url }
      end
    end
  end

  def diary_diary_day_time_path(*args)
    view_context.diary_diary_day_time_path(*args)
  end

end
