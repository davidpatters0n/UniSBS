class User < ActiveRecord::Base

  belongs_to :company
  belongs_to :admin_level

  validates_presence_of :company

  # Which devise modules to include
  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :lockable

  # Mass assignment on User table is not
  # recommended for security, so we disable it:
  attr_accessible :nil

  def is_global_admin?
    admin_level and admin_level.name == 'global'
  end

  def is_local_admin?
    admin_level and admin_level.name == 'local'
  end

  def is_an_admin?
    is_global_admin? or is_local_admin?
  end

  def is_booking_manager?
    company.is_internal?
  end
 
  def logged_in_as
    nickname or email
  end

  def users
    if is_global_admin?
      User.all
    else
      company.users
    end
  end

  def can_see_identifying_data(other)
    # When creating user, we can see the data to input it:
    return true if other.nil?
    return true if other.company_id.nil?
    # Normally can only see identifying data for users in same company:
    return true if company_id == other.company_id
    # exception is local adminstrators, visible to global administrators:
    return true if is_global_admin? and other.is_local_admin?
    return false
  end

  def can_access_user?(other)
    return false if other.nil?       # there must be a user
    return false unless other.valid? # the user must be valid
    return true if other.id == id    # can access yourself
    return true if is_local_admin? and users.find_by_id(other.id)
    return is_global_admin?          # default is no to all but global admins
  end

end
