class User < ActiveRecord::Base

  belongs_to :company
  belongs_to :admin_level

  validates_presence_of :company
  validate :validate_company_known

  def validate_company_known
    errors.add(:company, "must be known") unless company.is_known?
  end

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
    admin_level and (admin_level.name == 'local' or admin_level.name == 'local+grant')
  end

  def is_an_admin?
    is_global_admin? or is_local_admin?
  end

  def has_grant_privilege?
    admin_level and (admin_level.name == 'local+grant' or admin_level.name == 'global')
  end
  
  def is_internal?
    company.is_internal?
  end

  def is_external?
    company.is_external?
  end

  def is_booking_manager?
    company.is_internal?
  end

  def is_transport_user?
    company.is_external?
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

  def admin_levels_can_assign_to(other)
    result = []

    if is_global_admin? 
      if other.id.nil? or other.is_internal?
        # New or internal user, global admin can assign any privilege
        result = AdminLevel.all
      elsif other.is_local_admin?
        # Global admin can raise/lower privileges of local admins
        result = AdminLevel.where('name="local" or name="local+grant"')
      end
    elsif has_grant_privilege?
      # local admins with grant privileges can create local admins
      # or make local admins out of users from their own company
      if other.id.nil? or company_id == other.company.id
        result = AdminLevel.where('name="local"')
      end
    end

    return result
  end

end
