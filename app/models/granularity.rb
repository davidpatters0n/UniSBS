class Granularity < ActiveRecord::Base

  validates_presence_of :minutes
  validates_uniqueness_of :minutes
  validates :minutes, :numericality => { :only_integer => true, :greater_than => 0, :less_than => 24*60 }
  validate :divides_day_equally

  def divides_day_equally
    if (24*60).modulo(minutes) > 0
      errors.add(:minutes, "must divide day equally which #{minutes} does not")
    end
  end

  def slots_per_day
    (24*60).div(minutes)
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
