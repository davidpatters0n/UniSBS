class Company < ActiveRecord::Base

  has_many :users, :dependent => :restrict
  has_many :bookings, :dependent => :restrict

  validates_presence_of :name
  validates_uniqueness_of :name

  after_create   {|record| log("create")}
  after_update   {|record| log("update")}
  before_destroy {|record| log("delete")}

  def log(logclass_name)
    CompanyLogentry.create({
      :logclass_name => logclass_name,
      :name => name,
      :haulier_code => haulier_code})
  end

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
