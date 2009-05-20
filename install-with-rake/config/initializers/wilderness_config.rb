# Application Options

Wilderness::SECTIONS = ['Articles','Assets','Categories','Comments','Links','Pages','Permissions','Roles','Roles Permissions','Users']

Wilderness::DASHBOARD_SECTIONS = ['Articles','Assets','Categories','Comments','Links','Pages']    

Wilderness::CAN_BE_ADDED_TO_MENUS =  [ 'Article', 'Page', 'Tag', 'Category',  'Asset' ]

Wilderness::NON_EDITABLE_FIELDS = ['created_at','updated_at','state','activated_at','id','filename',
 'content_type','size','height','width','content']

# Section Options
 
Article.association_fields = {}
Article.custom_views = []
Article.filter_options = { :field => 'publish', :values => ['Yes','No'] }
Article.search_fields = ['Title']

Asset.association_fields = {} 
Asset.custom_views = []
Asset.filter_options = {}
Asset.omit_fields = ['parent_id','thumbnail','assetable_type','assetable_id','category_id']
Asset.custom_views = ['new','edit','show']

Category.association_fields = {}
Category.custom_views = []
Category.filter_options = {}
Category.omit_fields = ['created_at','updated_at']
Category.search_fields = ['name']

Comment.association_fields = {}
Comment.custom_views = []
Comment.filter_options = { :field => 'is_spam', :values => ['Yes','No'] }
Comment.omit_fields = ['user_id','commentable_id','commentable_type','permalink','parent_id','referrer','user_agent','user_ip','comment_type','marked']
Comment.search_fields = ['title','author','author_email','author_url','content']

ContentArea.association_fields = {}
ContentArea.custom_views = []
ContentArea.filter_options = {}
ContentArea.omit_fields = ['created_at','updated_at']
ContentArea.search_fields = []

Link.association_fields = {}
Link.custom_views = []
Link.filter_options = {}
Link.omit_fields = []
Link.search_fields = ['title','url']

MenuItem.association_fields = {}
MenuItem.custom_views = ['new','edit']
MenuItem.filter_options = {}
MenuItem.omit_fields = []
MenuItem.search_fields = []

Page.association_fields = {}
Page.custom_views = []
Page.filter_options = { :field => 'publish', :values => ['Yes','No'] }
Page.omit_fields = ['user_id']
Page.search_fields = ['title']

Permission.association_fields = {}
Permission.custom_views = []
Permission.filter_options = {}
Permission.omit_fields = ['created_at','updated_at']
Permission.search_fields = []

Role.association_fields = {}
Role.custom_views = []
Role.filter_options = {}
Role.omit_fields = []
Role.search_fields = ['name']
Role.custom_views = ['new','edit']

RolesPermission.association_fields = {}
RolesPermission.custom_views = []
RolesPermission.filter_options = {}
RolesPermission.omit_fields = ['created_at','updated_at']
RolesPermission.search_fields = []

User.association_fields = {}
User.filter_options = { :field => 'state', :values => ['Active','Passive','Pending','Suspended','Deleted'] }
User.omit_fields = ['salt','remember_token','activation_code','remember_token_expires_at','crypted_password']
User.search_fields = ['login','email','identity_url','created_at','updated_at','delete_at','state','name']
User.custom_views = ['new','edit']