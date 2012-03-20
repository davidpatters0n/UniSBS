class CompaniesController < PortalController
  
  before_filter :authorize

  def authorize
    access_denied unless current_user.is_global_admin?  
  end

  def index
    @companies = Company.all
    @main_heading = 'Companies'
  end

  def edit
    @company = Company.find(params[:id])
    @main_heading = 'Edit Company Details'
  end

  def update
    edit
    
    if @company.update_attributes(params[:company])
      flash[ :notice ] = 'Company updated'
    end

    render :edit
  end

end
