module WildernessHelper  

  ##############################################################################
  # BORT
  ##############################################################################

  
  #
  # Use this to wrap view elements that the user can't access.
  # !! Note: this is an *interface*, not *security* feature !!
  # You need to do all access control at the controller level.
  #
  # Example:
  # <%= if_authorized?(:index,   User)  do link_to('List all users', users_path) end %> |
  # <%= if_authorized?(:edit,    @user) do link_to('Edit this user', edit_user_path) end %> |
  # <%= if_authorized?(:destroy, @user) do link_to 'Destroy', @user, :confirm => 'Are you sure?', :method => :delete end %> 
  #
  #
  def if_authorized?(action, resource, &block)
    if authorized?(action, resource)
      yield action, resource
    end
  end

  #
  # Link to user's page ('users/1')
  #
  # By default, their login is used as link text and link title (tooltip)
  #
  # Takes options
  # * :content_text => 'Content text in place of user.login', escaped with
  #   the standard h() function.
  # * :content_method => :user_instance_method_to_call_for_content_text
  # * :title_method => :user_instance_method_to_call_for_title_attribute
  # * as well as link_to()'s standard options
  #
  # Examples:
  #   link_to_user @user
  #   # => <a href="/users/3" title="barmy">barmy</a>
  #
  #   # if you've added a .name attribute:
  #  content_tag :span, :class => :vcard do
  #    (link_to_user user, :class => 'fn n', :title_method => :login, :content_method => :name) +
  #          ': ' + (content_tag :span, user.email, :class => 'email')
  #   end
  #   # => <span class="vcard"><a href="/users/3" title="barmy" class="fn n">Cyril Fotheringay-Phipps</a>: <span class="email">barmy@blandings.com</span></span>
  #
  #   link_to_user @user, :content_text => 'Your user page'
  #   # => <a href="/users/3" title="barmy" class="nickname">Your user page</a>
  #
  def link_to_user(user, options={})
    raise "Invalid user" unless user
    options.reverse_merge! :content_method => :login, :title_method => :login, :class => :nickname
    content_text      = options.delete(:content_text)
    content_text    ||= user.send(options.delete(:content_method))
    options[:title] ||= user.send(options.delete(:title_method))
    link_to h(content_text), user_path(user), options
  end

  #
  # Link to login page using remote ip address as link content
  #
  # The :title (and thus, tooltip) is set to the IP address 
  #
  # Examples:
  #   link_to_login_with_IP
  #   # => <a href="/login" title="169.69.69.69">169.69.69.69</a>
  #
  #   link_to_login_with_IP :content_text => 'not signed in'
  #   # => <a href="/login" title="169.69.69.69">not signed in</a>
  #
  def link_to_login_with_IP content_text=nil, options={}
    ip_addr           = request.remote_ip
    content_text    ||= ip_addr
    options.reverse_merge! :title => ip_addr
    if tag = options.delete(:tag)
      content_tag tag, h(content_text), options
    else
      link_to h(content_text), login_path, options
    end
  end

  #
  # Link to the current user's page (using link_to_user) or to the login page
  # (using link_to_login_with_IP).
  #
  def link_to_current_user(options={})
    if current_user
      link_to_user current_user, options
    else
      content_text = options.delete(:content_text) || 'not signed in'
      # kill ignored options from link_to_user
      [:content_method, :title_method].each{|opt| options.delete(opt)} 
      link_to_login_with_IP content_text, options
    end
  end

  # Sets the page title and outputs title if container is passed in.
  # eg. <%= title('Hello World', :h2) %> will return the following:
  # <h2>Hello World</h2> as well as setting the page title.
  def title(str, container = nil)
    @page_title = str
    content_tag(container, str) if container
  end
  
  # Outputs the corresponding flash message if any are set
  def flash_messages
    messages = []
    %w(notice warning error).each do |msg|
      messages << content_tag(:div, html_escape(flash[msg.to_sym]), :id => "flash-#{msg}") unless flash[msg.to_sym].blank?
    end
    messages
  end

##############################################################################
# FRONT END 
##############################################################################

  def content_area area
    render :partial => 'content_areas/content_area', :locals => { :area => area }
  end
     
  def menu menu
    display = ""
    menu.each do |menu_item|
      if menu_item.menu_itemable.attributes.include?('title') 
				display += link_to menu_item.menu_itemable.title, menu_item.menu_itemable
			elsif menu_item.menu_itemable.attributes.include?('name')
					display += link_to menu_item.menu_itemable.name, menu_item.menu_itemable
			end 
		end unless @main_menu.blank?
		return display
  end
  
  # CONTENT BLOCKS
  def method_missing meth, *args
    if meth.to_s =~ /^(.+)_block$/  
      partial = $1.gsub(' ','_') 
      render :partial => "wilderness/content_blocks/#{partial}" 
    else
      super meth, args
    end
  end
 
  def zebra
    cycle('odd','even')
  end

  def audio_player item
    render :partial => 'partials/audio_player', :locals => { :item => item }
  end

  def video_player item
    render :partial => 'partials/video_player', :locals => { :item => item }
  end 

  def comments_for item                                                                 
    klass = item.class
    render :partial => 'comments/comments', :locals => { :klass => klass, :item => item }
  end

##############################################################################
# BACK END
##############################################################################

  def tree_class_for item
    if item.attributes.include?("parent_id")
      if item.parent_id.blank? || item.parent_id == 0
        'parent'
      elsif item.children.blank?
        'no-children'
      else    
        'has-children'
      end                     
    end 
  end  

  def navigation
    render :partial => 'admin/wilderness/layouts/admin_navigation'
  end

  def colspan
    colspan = @klass.columns.length + 4
    colspan += 1 if @klass.public_instance_methods.include?('tags')
    colspan += 1 if @klass.public_instance_methods.include?('comments')
    colspan += @klass.association_fields.keys.length if @klass.responds_to?('association_fields') && !@klass.association_fields.blank?  
    colspan
  end

  def toggle_check_boxes klass
    "<input type='checkbox' onclick='Wilderness.toggleCheckBoxes(this,\".#{klass.to_s.downcase.gsub(' ','_').singularize}\")'/>"  
  end

  def act_on_checked arguments
    class_name = arguments[:class] 
    path = arguments[:path]                          
    "<input type='submit' value='Go' onclick='return Wilderness.act_on_checked(\"#{class_name}\",\"#{path}\")'  style='display:inline;margin:0'/>"
  end

  def new_item_link klass    
    unless klass.responds_to?('admin_disabled_actions') and klass.admin_disabled_actions.include?('new')
      x = "<div style='float:left;margin-right:15px;padding-top:5px'>"
      x += link_to image_tag("wilderness/buttons/add-new.png"), new_polymorphic_path([:admin,klass]) 
      x += "</div>"
    end
  end
  
  def header klass
    render :partial => 'admin/wilderness/partials/header', :locals => { :klass => klass }
  end
  
  # HELPER FOR SORTBALE TABLE HEADER LINKS
  # ASSUMES SORT GROUP EQUALS CONTROLLER NAME (SHOULD ALLOW BYPASS IF OPTION PASSED) 
  # ARGUMENT IS THE ALIAS NAME 
  def sort item
    klass = controller_name
    link_to item.titlecase, sort_param(klass, :field => item.downcase.gsub(' ','_'))
  end
  
  # HELPER THAT WORKS IN TANDEM WITH APPLICATION CONTROLLER FILTERED?
  # filter_by(:options =>ARRAY OF POSSIBLE_VALUES_FOR_THIS_FIELD, :model =>'users',:field=>'state')
  def filter_by args, path = "/admin/#{controller_name}"             
    options = args[:options].map { |option| 
        [option,"#{args[:model]}-#{args[:field]}-#{option.downcase}"]
     }
    options = options_for_select(options,session[:filter_by])
    "View By #{args[:model].singularize.titlecase}: “#{args[:field].titlecase}” <select onchange='return Wilderness.filter(this,\"#{path}\");'>#{options}</select>"
  end

  def search_form args
    render :partial => 'admin/wilderness/partials/search_form', :locals => { :path => args[:path], :options => args[:options] }
  end
   
  def wilderness_submit
    image_submit_tag 'wilderness/buttons/ok.png', :id => 'Go'
  end
  
  def preferences_table collection
    # this only works (by chance) for 3 columns layout, because the math is weak 
    columns = 3.to_f
    records = @preferences.length.to_f 
    rows = records / columns          
    if rows % columns == 0
    	rows = rows
    else
    	rows = rows.to_i + 1	
    end	
    total_cells = rows * columns
    empty_cells = (total_cells - records).to_i
    row = 0               
    group_name = collection.first.class.to_s.downcase.pluralize
    object_name = group_name.singularize
    
    table = "<table id='#{group_name}' class='#{group_name}'>"
    collection.each_with_index do |item,index|
      if index % columns == 0
        table += "<tr>"
        row += 1
      end
  	table += "<td id='#{object_name}_item.id'>"
 	  table + "<label>"
 	  table += item.title.humanize.titlecase
 	  table += "</label>"
 	  
 	 # CATEGORIES
 	 if item.title == "default_category"
 	   table += "<br />"        
 	   table += "<select name='preferences[default_category]'>"
 	   table += options_for_select Category.all.map(&:title)
 	   table += "</select>"
 	# ADD A COLUMN TO PREFS TABLE THAT SPECIFIES THE TYPE OF PREF -- SO BOOLEAN WOULD GIVE YOU A YES/NO RADIO BUTTON

=begin
   	  # THEMES
   	  elsif item.title == "theme"
   	   table += "<br />"
   	    theme_directory_entries = Dir.entries(Wilderness::THEMES_PATH)          
        @themes = theme_directory_entries.reject { |t| t == "." || t == ".." }
   	  table += "<select name='preferences[theme]'>"
      table += options_for_select @themes.map(&:titlecase), @themes
   	  table += "</select>"      
=end
 	
	# TEXT FIELDS
  else
 	  table += "<input type='text' name='preferences[#{item.title}]' value='#{item.setting}'/>"
    
  end
 	  
    table += "</td>"
  	  if row == rows
  			empty_cells.times do
  				table += "<td></td>"
  		  end
  		end
      if index +1 % columns == 0
        table += "</tr>"
      end
    end             
    table += "</table>"
  end

  def show_link path
    link_to image_tag('wilderness/icons/magnifier.png'), path, :title => 'Show' 
  end

  def edit_link path
    link_to image_tag('wilderness/icons/pencil.png'), edit_polymorphic_path(path), :title => 'Edit'
  end
  
  def delete_link path
    link_to_remote image_tag('wilderness/icons/delete.png'), :url => path, :method => :delete, :confirm => 'Are you sure', :title => 'Delete'
  end
  
  def custom_view args
    args[:klass].responds_to?("custom_views") and !args[:klass].custom_views.blank? and args[:klass].custom_views.include?(args[:view])
  end
  
  def text_editor
    "mceEditor" if @preferences.text_editor == 'TinyMCE'
  end
   
  def formatted_text field
    case @preferences.text_editor
      when "TinyMCE" || "Plain" || ""
        field
      when "Textile"
        textilize(field)
      when "Markdown"
        markdown(field)
      when "Simple Format"
        simple_format(field)
      else
        field
      end
  end
    
end