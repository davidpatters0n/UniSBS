class SlotTimesController < ApplicationController
  # GET /slot_times
  # GET /slot_times.json
  def index
    @slot_times = SlotTime.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @slot_times }
    end
  end

  # GET /slot_times/1
  # GET /slot_times/1.json
  def show
    @slot_time = SlotTime.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @slot_time }
    end
  end

  # GET /slot_times/new
  # GET /slot_times/new.json
  def new
    @slot_time = SlotTime.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @slot_time }
    end
  end

  # GET /slot_times/1/edit
  def edit
    @slot_time = SlotTime.find(params[:id])
  end

  # POST /slot_times
  # POST /slot_times.json
  def create
    @slot_time = SlotTime.new(params[:slot_time])

    respond_to do |format|
      if @slot_time.save
        format.html { redirect_to @slot_time, notice: 'Slot time was successfully created.' }
        format.json { render json: @slot_time, status: :created, location: @slot_time }
      else
        format.html { render action: "new" }
        format.json { render json: @slot_time.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /slot_times/1
  # PUT /slot_times/1.json
  def update
   @slot_time = Diary.find(params[:diary_id]).slot_days.where
   (:day => Date.parse(params[:slot_day]).first.slot_times.all.find 
   { |t| t.time_slot.strftime("%H:%M") == params[:time] }

    respond_to do |format|
      if @slot_time.update_attributes(params[:slot_time])
        format.html { redirect_to @slot_time, notice: 'Slot time was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @slot_time.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /slot_times/1
  # DELETE /slot_times/1.json
  def destroy
    @slot_time = SlotTime.find(params[:id])
    @slot_time.destroy

    respond_to do |format|
      format.html { redirect_to slot_times_url }
      format.json { head :ok }
    end
  end
end

