class UsersController < PortalController

  # authorize
  before_filter :authorize_admin, :only => [ :index, :new, :create ]
  before_filter :authorize_visible, :except => [ :index, :new, :create ]
  before_filter :setup_edit_instance_vars, :only => [ :edit, :update ]

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
    else
      @user = current_user
      @main_heading = 'My Account'
    end
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
      respond_to { |format| redirect_to routing_error_path }
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
      respond_to { |format| redirect_to routing_error_path }
    end

  end

  # GET /users/new
  def new
    @user = User.new
    @main_heading = "Create New User"

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /users
  def create
    @user = User.new
    @main_heading = "Create New User"
    
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
        if value != user.admin_level_id.to_s and current_user.is_global_admin?

          # Admin cannot take rights away from himself            
          if user.id == current_user.id
            flash[:alert] = 'Cannot change own admin privilege'
            return false
          end

          user.admin_level_id = value
        end

      when 'company_id'
        if value != user.company_id.to_s and current_user.is_an_admin?

          if user.is_global_admin?
            flash[:alert] = 'Global admin cannot change companies'
            return false
          end

          if current_user.is_global_admin?
            user.company_id = value          
          elsif current_user.is_local_admin? and value == current_user.company_id.to_s
            # local admin can set a new user to own company
            user.company_id ||= current_user.company_id
          end

        end
      else
        logger.debug "Not processing user param #{key}:=#{value}"
      end
    end
    
    user.save
  end

end
