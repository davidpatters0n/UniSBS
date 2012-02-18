class BookingsController < ApplicationController
  
  before_filter :authorise

  def authorise
    current_user.is_booking_manager?
  end


  def confirm
    raise "oy, boy!"
  end
  
  # GET /bookings
  # GET /bookings.json
  def index
    @bookings = Booking.all
    @main_heading = 'Bookings'

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

  # GET /bookings/new
  # GET /bookings/new.json
  def new
    @booking = Booking.new
    @main_heading = 'Manually Create Booking'

    respond_to do |format|
      format.html # new.html.erb
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

    respond_to do |format|
      if @booking.update_attributes(params[:booking])
        format.html { redirect_to @booking, notice: 'Booking was successfully updated.' }
      else
        @main_heading = 'Manually Edit Booking'
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
