SBSPortal::Application.routes.draw do

  # Routes for authenticating users
  devise_for :users

  # Dashboard root
  root :to => 'dashboard#index'

  #
  # Routes for inspecting data
  #

  # Bookings can be created only through the SOA or diary screen, so we don't include the new action:
  resources :bookings, :except => :new

  #
  # Administrative routes
  #
  
  # go to admin dashboard page with /admin:
  get  '/admin'  => 'dashboard#admin',  :as => 'admin'

  # For admin pages we skip adding edit to the end of the path;
  # we can do this because we don't use the show action
  scope "/admin", :path_names => { :edit=>"" } do

    match 'controlpanel' => 'controlpanel#show', :via => :get
    post 'controlpanel/restart_housekeeper' => 'controlpanel#restart_housekeeper', :as => 'controlpanel_restart_housekeeper'
    
    # /admin/users/1
    resources :users, :except => [:show]
    
    # /admin/companies/1
    resources :companies, :except => [:show]
    
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
  post '/housekeeper/endofday' => 'housekeeper/housekeeper#endofday'

  #
  # Diary pages
  #
  
  # Go to the diary page of a site directly with
  # /cannock, /doncaster which redirects to current day
  # Then slot_day resources are /cannock/20120101
  resources :sites, :only => [:show], :path => "", :as => :diary do
    resources :slot_days, :path => "", :only => [:show]
    resources :slot_times do
      post 'add_slot' => 'slot_days#add_slot', :as => 'add_slot'
      post 'remove_slot' => 'slot_days#remove_slot', :as => 'remove_slot'
      put 'set_capacity' => 'slot_days#set_capacity', :as => 'set_capacity'
    end
  end
  
  ###################################################
  # Fallback routes; don't put anything after this! #
  ###################################################
  match '/soa/*a', :to => 'soa/errors#routing'
  match '*a', :to => 'errors#routing'
end
