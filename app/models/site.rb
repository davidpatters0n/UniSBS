class Site < ActiveRecord::Base

  belongs_to :granularity
  
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :granularity

  validates :past_days_to_keep, :numericality => {
    :only_integer => true,
    :greater_than => 0}
  validates :days_in_advance, :numericality => {
    :only_integer => true,
    :greater_than => 0}
  validates :provisional_bookings_expire_after, :numericality => {
    :only_integer => true,
    :greater_than => 0}

  # Everything except the name should be modifiable by global admin:
  attr_protected :name

  def self.names
    ['Cannock', 'Doncaster']
  end

  def to_param
    name.camelize
  end

end
