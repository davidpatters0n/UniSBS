module SitesHelper

  def id_for_timerow(time_slot_capacity)
    #"time_%04d" %
    time_slot_capacity.minutes
  end

end
