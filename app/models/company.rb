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
      :company_id => id, 
      :name => name,
      :haulier_code => haulier_code})
  end

  def is_internal?
    id == 1
  end
  
  def is_external?
    not is_internal?
  end
end
