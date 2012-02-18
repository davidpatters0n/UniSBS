class BookingsController < PortalController

  # GET /bookings
  # GET /bookings.json
  def index
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

  # POST /bookings
  # POST /bookings.json
  def create
    @booking = Booking.new(params[:booking])
    @site = @booking.site
    @slot_day = @booking.slot_day
    if @booking.save
      if @site and @slot_day
      flash[:notice] = 'Booking was successfully created'
        respond_to do |format|
          format.html { redirect_to diary_slot_day_path(@booking.site, @booking.slot_day) }
        end
      else
        # we shouldn't get here, since provisional bookings should always be
        # against a slot time, day and site. But just in case...
        flash[:error] = 'Unexpectedly could not go to site or day of booking'
        respond_to do |format|
          format.html { redirect_to booking_path(@booking) }
        end
      end
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
    updated = @booking.update_attributes(params[:booking])
    @site = @booking.site
    @slot_day = @booking.slot_day
    if updated
      if @site and @slot_day
      flash[:notice] = 'Booking was successfully updated'
        respond_to do |format|
          format.html { redirect_to diary_slot_day_path(@booking.site, @booking.slot_day) }
        end
      else
        # we shouldn't get here, since provisional bookings should always be
        # against a slot time, day and site. But just in case...
        flash[:error] = 'Unexpectedly could not go to site or day of booking'
        respond_to do |format|
          format.html { redirect_to booking_path(@booking) }
        end
      end
    else
      @main_heading = 'Review Booking'
      respond_to do |format|
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy

    respond_to do |format|
      format.html { redirect_to bookings_url }
    end
  end
end
