class BaseLogentry < ActiveRecord::Base
  has_one :logentry, :as => :loggable

  attr_accessor :logclass_name

  after_create do |record|
    logentry = Logentry.find_or_initialise_by_loggable_id(id)
    logentry.logclass_id = Logclass.find_or_create_by_name(logclass_name).id
  end

end
