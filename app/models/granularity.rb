class Granularity < ActiveRecord::Base

  validates_presence_of :minutes
  validates_uniqueness_of :minutes
  validates :minutes, :numericality => { :only_integer => true, :greater_than_or_equal_to => 5, :less_than => 24*60 }
  validate :divides_day_equally

  def divides_day_equally
    if (24*60).modulo(minutes) > 0
      errors.add(:minutes, "must divide day equally which #{minutes} does not")
    end
  end

  def slots_per_day
    (24*60).div(minutes)
  end

  def self.allowed_minutes
    # 0, 5, 10, 15, ... 1435 minutes
    # corresponding to 00:00, 00:05, ... 23:55
    0.step(1435, 5)
  end

  # This method takes an array of integers and creates the slot length
  # granularities from them.
  def self.construct_selection!(array_of_minutes)
    array_of_minutes.each do |mins|
      unless find_by_minutes(mins)
        granularity = Granularity.new
        granularity.minutes = mins
        granularity.save!
      end
    end
  end

end
