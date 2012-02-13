SBSPortal::Application.routes.draw do

  # Routes for authenticating users
  devise_for :users

  # Dashboard root
  root :to => 'dashboard#index'

  #
  # Routes for inspecting data
  #

  resources :bookings
  #resources :slot_times
  #resources :slot_days

  #
  # Administrative routes
  #
  
  # go to admin dashboard page with /admin:
  get  '/admin'  => 'dashboard#admin',  :as => 'admin'

  # For admin pages we skip adding edit to the end of the path;
  # we can do this because we don't use the show action
  scope "/admin", :path_names => { :edit=>"" } do

    # /admin/users/1
    resources :users, :except => [:show]
    
    # /admin/companies/1
    resources :companies, :except => [:show, :destroy]
    
    # sites have fixed names and cannot be created/deleted through user
    # action. To give a clean URL, we skip having 'sites' in the path.
    # /admin/cannock, /admin/doncaster
    resources :sites, :path => "", :only=> [:edit, :update]
   
    match ':id/slots' => 'sites#edit_slots', :via => :get
    match ':id/slots' => 'sites#update_slots', :via => :post
  end
  
  # /myaccount shortcut to current users account
  resource :myaccount, :only => [:edit, :update], :path_names => { :edit=>""}, :controller=>"users"

  #
  # Transaction Logs (TODO)
  #
  get '/logs' => 'dashboard#logs', :as => 'logs'

  resources :logentries
  
  #
  # Search bar
  #
  post '/search' => 'dashboard#search', :as => 'search'

  #
  # Soa (Web Service) Routes
  #

  post    '/soa/bookings/confirm'              => 'soa/bookings#confirm'

  ###################################################
  # Housekeeper -- background processing            #
  ###################################################
  get '/housekeeper' => 'housekeeper/housekeeper#tip'
  post '/housekeeper' => 'housekeeper/housekeeper#tip'

  #
  # Diary pages
  #
  
  # Go to the diary page of a site directly with
  # /cannock, /doncaster which redirects to current day
  # Then slot_day resources are /cannock/20120101
  resources :sites, :only => [:show], :path => "", :as => :diary do
    resources :slot_days, :path => "", :only => [:show]
  end
  
  get "/slot_days/bookingmangement"
  get "/slot_days/transport"
  
  ###################################################
  # Fallback routes; don't put anything after this! #
  ###################################################
  match '/soa/*a', :to => 'soa/errors#routing'
  match '*a', :to => 'errors#routing'
end
