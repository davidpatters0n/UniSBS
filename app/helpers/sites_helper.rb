module SitesHelper

  def id_for_timerow(template_capacity)
    #"time_%04d" %
    template_capacity.minutes
  end

end
