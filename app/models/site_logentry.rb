class SiteLogentry < ActiveRecord::Base

  has_one :logentry, :as => :loggable, :dependent => :destroy
  belongs_to :site

  attr_accessor :logclass_name

  after_create do |record|
    logentry = Logentry.new
    logentry.loggable = self
    logentry.logclass_id = Logclass.find_or_create_by_name(logclass_name).id
    logentry.save
  end

  def content_summary
    "#{site.name}"
  end
end
