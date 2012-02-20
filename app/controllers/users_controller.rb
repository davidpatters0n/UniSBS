class UsersController < PortalController

  # authorize
  before_filter :authorize_admin, :only => [ :index, :new, :create ]
  before_filter :authorize_visible, :except => [ :index, :new, :create ]
  before_filter :setup_edit_instance_vars, :only => [ :edit, :update ]
  before_filter :setup_new_instance_vars, :only => [ :new, :create]

  #
  # Filter methods
  #

  def authorize_admin
    access_denied unless current_user.is_an_admin?
  end

  def authorize_visible
    access_denied if params[:id] and not current_user.can_access_user?(User.find_by_id(params[:id]))
  end

  def setup_edit_instance_vars
    if params[:id] and params[:id] != current_user.id.to_s
      @user = User.find_by_id(params[:id])
      @main_heading = 'Edit User Details'
      @own_account = false
    else
      @user = current_user
      @main_heading = 'My Account'
      @own_account = true
    end
    @admin_levels = current_user.admin_levels_can_assign_to(@user)
  end

  def setup_new_instance_vars
    @user = User.new
    @main_heading = "Create New User"
    @own_account = false

    # only used by global admins:
    @admin_levels = current_user.admin_levels_can_assign_to(@user)
  end

  #
  # Request methods
  #

  # GET /users
  # GET /users.xml
  def index
    @users = current_user.users
    @main_heading = 'User List'
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /users/:id/edit
  def edit
    if @user
      respond_to do |format|
        format.html # edit.html.erb
      end
    else
      redirect_to routing_error_path
    end
  end

  # POST /users/:id
  def update

    if @user
      if assign_account_details(@user)
        flash[:notice] = 'User profile updated'

        if @user.id == current_user.id
          respond_to { |format| format.html { redirect_to myaccount_path }}
        else
          respond_to { |format| format.html { redirect_to edit_user_path(@user) }}
        end
      else
        setup_edit_instance_vars
        respond_to { |format| format.html { render :edit, :location=> myaccount_url } }
      end
    else
      redirect_to routing_error_path
    end

  end

  # GET /users/new
  def new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /users
  def create
    if assign_account_details(@user)
      flash[:notice] = 'User was successfully created'
      respond_to { |format| format.html { redirect_to edit_user_path(@user) } }
    else
      respond_to { |format| format.html { render :action => "new" } }
    end
  end


  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])

    if @user.id == current_user.id
      flash[:alert] = "cannot delete your own account"
    else
      @user.destroy
    end
      
    respond_to do |format|
      format.html { redirect_to(users_url) }
    end
  end

  def assign_account_details(user)
    
    return false if params[:user].nil?

    params[:user].each do |key, value|
      case key

      when 'password'
        # password blank when displayed, just means we're not changing it
        unless value.blank?
          user.password = value
        end

      when 'password_confirmation'
        # as with password, blank means not changed
        unless value.blank?
          user.password_confirmation = value
        end

      when 'email'
        user.email = value

      when 'nickname'
        user.nickname = value

      when 'remember_me'
        user.remember_me = value

      when 'admin_level_id'
        if value != user.admin_level_id.to_s
          
          unless current_user.has_grant_privilege?
            flash[:alert] = 'You do not have that privilege'
            return false
          end

          # Admin cannot take rights away from himself            
          if user.id == current_user.id
            flash[:alert] = 'Cannot change own admin privilege'
            return false
          end

          if value.empty? or current_user.admin_levels_can_assign_to(user).collect{|a| a.id.to_s}.include?(value)
            user.admin_level_id = value
          else
            flash[:alert] = "Disallowed change of admin level for that user"
            return false
          end
        end

      when 'company_id'
        # cannot change, only assign for new user
        if user.company_id.nil? and current_user.is_global_admin?
          user.company_id = value      
        end
      else
        logger.debug "Not processing user param #{key}:=#{value}"
      end
    end

    if user.company_id.nil?
      # local admin can set a new user to own company
      user.company_id ||= current_user.company_id
    end

    user.save
  end

end
