class Company < ActiveRecord::Base

  has_many :users

  validates_presence_of :name
  validates_uniqueness_of :name

  def self.internal_name
    'internal'
  end

  def is_internal?
    name == Company.internal_name
  end
  
  def is_external?
    not is_internal?
  end

  # a nice named scope for all the transport companies
  scope :external, where("name != ?", Company.internal_name)
end
