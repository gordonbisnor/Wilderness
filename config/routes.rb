ActionController::Routing::Routes.draw do |map|

  # FRONT END                 
  map.search '/search/:search', :controller => 'search', :action => 'index'
  map.search '/search', :controller => 'search', :action => 'index'

  map.resources :tags, :only => [:show]
  map.resources :pages, :only => [:show]
  map.resources :articles, :only => [:show,:index], :collection => { 'archives' => :get }
  map.resources :comments, :only => [:index,:create]
  map.resources :categories, :only => [:index,:show]
  
  # Restful Authentication Resources
  map.resources :users
  map.resources :passwords
  map.resource :session

  map.namespace :admin do |admin|            
    admin.resources :menu_items
    admin.resources :menus
    admin.resources :tags
    admin.resources :permissions
    admin.resources :roles_permissions
    admin.resources :users
    admin.resources :roles
    admin.resources :pages
    admin.resources :articles 
    admin.resources :comments 
    admin.resources :links     
    admin.resources :categories    
    admin.resources :content_areas  
    admin.resources :content_blocks  
    admin.resources :preferences, :collection => { :adjust => :put }   
    admin.resources :assets, :collection => { 'file_browser' => [:get,:post] }    
  end

  # ADMIN
  map.connect '/admin/', :controller => 'admin/admin', :action => 'dashboard'
  map.dashboard '/admin/dashboard', :controller => 'admin/admin', :action => 'dashboard'

  # Restful Authentication Rewrites
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'
  map.change_password '/change_password/:reset_code', :controller => 'passwords', :action => 'reset'
  map.open_id_complete '/opensession', :controller => "sessions", :action => "create", :requirements => { :method => :get }
  map.open_id_create '/opencreate', :controller => "users", :action => "create", :requirements => { :method => :get }
    
  # Home Page
  map.root :controller => 'articles', :action => 'index'

  map.connect 'articles/:year/:month/',
                :controller => 'articles',
                :action     => 'find_by_date',
                :year       => /\d{4}/,
                :month      => /\d{1,2}/


  map.connect ':id', :controller => 'pages', :action => 'show'

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

end
