class CompaniesController < PortalController
  
  before_filter :authorize

  def authorize
    access_denied unless current_user.is_global_admin?  
  end

  # GET /companies
  # GET /companies.xml
  def index
    @companies = Company.external
    @main_heading = 'Company List'
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /companies/:id/edit
  def edit
    @company = Company.find(params[:id])
    @main_heading = 'Edit Company Details'

    respond_to do |format|
      format.html # edit.html.erb
    end
  end

  # POST /companies/:id
  def update
    @company = Company.find(params[:id])  
    @main_heading = 'Edit Company Details'
    
    flash[ :notice ] = 'Company updated' if assign_company_details(@company)

    respond_to do |format|
      format.html do
          render :edit
      end
    end
  end

  # GET /companies/new
  def new
    @company = Company.new
    @main_heading = "Create New Company"

    respond_to do |format|
      format.html # new.html.erb
    end
  end


  # POST /companies
  def create
    @company = Company.new
    @main_heading = "Create New Company"

    saved = assign_company_details(@company)

    respond_to do |format|
      if saved
        format.html { redirect_to companies_path,
                             :notice => 'Company was successfully created' }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def destroy
    begin
      @company = Company.find_by_id(params[:id])
      @company.destroy
    rescue => e
      flash[:error] = e.message
    end

    respond_to do |format|
      format.html { redirect_to(companies_url) }
    end
  end

  def assign_company_details(company)

    if company.is_internal?
      flash[:error] = "Invalid name"
      return false
    end

    if params[:company][:name]
      if params[:company][:name] == Company.internal_name
        flash[:error] = "Invalid name"
        return false
      end
      
      company.name = params[:company][:name]
    end

    if params[:company][:haulier_code]
      company.haulier_code = params[:company][:haulier_code]
    end

    company.save
  end

end
