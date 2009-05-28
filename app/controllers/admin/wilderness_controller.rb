class Admin::WildernessController < ApplicationController
  layout 'admin/wilderness/layouts/application'  
  
  skip_before_filter :set_sortable_sections_default_scopes
  skip_before_filter :get_menu_items
  skip_before_filter :get_content_areas
  
  before_filter :must_be_logged_in , :except => [:widget_create,:widget_index]
  before_filter :must_have_permission
  before_filter :get_item, :only => [:destroy,:show,:edit,:update]
  before_filter :get_group_action_ids, :only => [:delete_checked,:mark_as_ham,:mark_as_spam,:publish,:unpublish,:open_for_comments,:close_for_comments,:disable_comments]
  before_filter :setup_in_place_editing, :except => [:dashboard]

  protect_from_forgery :except => [:delete_checked, :publish,:unpublish,:mark_as_spam,:mark_as_ham,:open_for_comments,:close_for_comments,:disable_comments,:update_item_list]                          

  uses_tiny_mce :only => [:new,:edit], :options => {
                               :theme => 'advanced',
                               :theme_advanced_resizing => true,
                               :theme_advanced_resize_horizontal => false,
                               :plugins => %w{ table fullscreen paste advimage_wilderness},
                               :file_browser_callback => "myFileBrowser",
                             	 :paste_create_paragraphs => false,
                               :paste_create_linebreaks => false,
                               :paste_use_dialog =>  true,
                               :paste_auto_cleanup_on_paste =>  true,
                               :paste_convert_middot_lists  => false,
                               :paste_unindented_list_class  => "unindentedList",
                               :paste_convert_headers_to_strong => true,
                               :theme_advanced_buttons3_add => %w{ pastetext,pasteword,selectall,fullscreen, advimage }
                             }

  def dashboard           
    @timeline_events = TimelineEvent.paginate(:page => params[:page], :per_page => 5)                           
    @dashboard_sections = Wilderness::DASHBOARD_SECTIONS
    render :template => 'admin/wilderness/pages/dashboard'
  end

  def index 
    add_to_sortables 
    conditions = { :page => params[:page], :order => sortable_order("#{controller_name}") }
    @conditions = filtered? conditions
    if block_given? 
      @items = yield.paginate conditions
    else
      if params[:view] == 'list'           
        if @klass.column_names.include?("parent_id")
          @items = @klass.find(:all,:conditions => 'parent_id IS NULL')
        else
          @items = @klass.all
        end
      else
        @items = @klass.paginate conditions  
      end
    end
    @wilderness = WildernessView.new(@items) unless @items.blank?
    unless params[:view] == 'list'
      render :template => 'admin/wilderness/pages/index'
    else
      render :template => 'admin/wilderness/pages/list'
    end  
  end

  def sort
    params[:items].each_with_index do |id, pos|
      @klass.find(id).update_attribute(:position, pos+1)
    end
    render :nothing => true
 end
    
    
  def show
    @wilderness = WildernessView.new(@item) unless @item.blank?
    unless @klass.responds_to?("custom_views") and @klass.custom_views.include?('show')
      render :template => 'admin/wilderness/pages/show'
    else
      render :template => "admin/#{controller_name}/show"
    end
  end

  def new
    @item = @klass.new
    @wilderness = WildernessForm.new(@item)
    render :template => 'admin/wilderness/pages/new'
   end

  def edit
    @wilderness = WildernessForm.new(@item)
    render :template => 'admin/wilderness/pages/edit'
  end

  def create
    @item = @klass.new(params[@klass.to_s.underscore.downcase.to_sym])
    @item.user_id = @current_user.id if @klass.column_names.include?('user_id')
   if @item.save
      flash[:notice] = "#{@klass} Created"
      redirect_to [:admin,@item]
    else     
      @wilderness = WildernessForm.new(@item)                                    
      render :template => "admin/wilderness/pages/new"
    end
  end

  def update 
    if @item.update_attributes(params[@klass.to_s.underscore.downcase.to_sym])
      flash[:notice] = "#{@klass} Updated"
      redirect_to [:admin,@item]
    else
      @wilderness = WildernessForm.new(@item)                                    
      render :template => "admin/wilderness/pages/edit"
    end
  end
      
  def search
    search_valid? ? get_items_by_search : @items = nil
    @wilderness = WildernessView.new(@items)
    render :template => "admin/wilderness/pages/index"
  end
  
  def destroy 
    action = @klass == User ? 'delete!' : 'destroy'
    if @item.send(action)
      respond_to do |format|
        format.html {
          flash[:notice] = "#{@klass} Deleted"
          redirect_to "/admin/#{controller_name}"
        }
        format.js { render :template => 'admin/wilderness/pages/destroy' }
      end
    end 
  end

  def delete_checked
    @ids = params[:ids].split(',').map { |item| item.to_i }.join(',')
    @items = @klass.delete_all("id IN(#{@ids})")
    respond_to do |format|
      format.html { redirect_to "/admin/#{controller_name}/" }
      format.js { 
        @item_type = @klass.to_s.underscore.downcase 
        render :template => 'admin/wilderness/pages/delete_checked'
        }                             
    end
  end

  def open_for_comments
    update_items_comment_state { "open_to_comments!" }  
  end
  
  def close_for_comments
    update_items_comment_state { "close_to_comments!" }
  end
  
  def disable_comments
    update_items_comment_state { "disable_comments!" }
  end    

  def update_items_comment_state
    conditions = "id IN(#{@ids})"
    @items = @klass.find(:all, :conditions => conditions)
    @items.map { |item| item.send(yield) }
      respond_to do |format|
        format.html { redirect_to "/admin/#{controller_name}" }
        format.js { 
          @item_type = @klass.to_s.downcase
          @column = 'comment_state'
          if yield == 'open_to_comments!'
            @status = 'Open'
          elsif yield == 'close_to_comments!'
            @status = 'Closed'
          elsif yield == 'disable_comments!'
            @status = 'Disabled'
          end
          render :template => 'admin/wilderness/pages/update_column_status'
          }                             
      end  
  end
  
  def publish 
    update_publish_status 'publish'
  end     

  def unpublish 
    update_publish_status 'unpublish'
  end

  private

    def update_publish_status status
      boolean = status == 'publish' ? 1 : 0
      @items = @klass.update_all( "publish = #{boolean}", "id IN(#{@ids})")
    
      respond_to do |format|
        format.html { redirect_to "/admin/#{controller_name}" }
        format.js { 
          @item_type = @klass.to_s.underscore.downcase
          @status = status == 'publish' ? 'Yes' : 'No'     
          @column = 'publish'
          render :template => 'admin/wilderness/pages/update_column_status'
          }                             
      end  
    end 

    def get_group_action_ids
      @ids = parse_ids_from_comma_separated params[:ids]
    end

    def parse_ids_from_comma_separated list
      list.split(',').map { |item| item.to_i }.join(',')
    end
    
    def search_valid?           
       params[:field] and @klass.search_fields.include?(params[:field]) ? true : false
     end

    def get_items_by_search
       field = params[:field]
       @items = @klass.paginate :page => params[:page], :conditions => ["#{field} LIKE ?","%%#{params[:value]}%%"]
     end 
 

    def add_to_sortables
      listing_name = controller_name
      model_name = @klass
      @klass.columns.each do |column|
        field_name = column.name
        add_to_sortable_columns(listing_name, :model => model_name, :field => field_name, :alias => field_name)
      end 
    end
    
    def filtered? conditions
        if session[:filter_by] || params[:filter_by]
          filter_by = session[:filter_by] =  params[:filter_by] || session[:filter_by]
         end                       
         unless filter_by.nil?
           filter_by = filter_by.split('-')
           klass = filter_by[0]
           field = filter_by[1]
           value = filter_by[2]
           if value == 'yes'
             value ='1'
           elsif value == 'no'
             value = '0'
           end  
           conditions.merge!({:conditions => ["#{klass}.#{field} = ?",value]}) if klass == controller_name
         end
         return conditions
     end
 
    def get_item
      @item = @klass.find(params[:id])
    end
 
    def must_be_logged_in
      no_access_redirect unless logged_in? # and current_user.has_role? Admin
    end                              
   
   def must_have_permission
     no_access_redirect unless current_user.has_permission?(self.action_name)
   end                     
   
   def no_access_redirect
     flash[:error] = "You do not have access to that."
     redirect_to login_path 
   end  
     
   def setup_in_place_editing
       @klass.columns.each do |field|
         unless Wilderness::NON_EDITABLE_FIELDS.include?(field.name)
         ApplicationController::in_place_edit_for(@klass.to_s.downcase.to_sym, field.name.to_s.downcase.to_sym)      
         end 
     end
   end    
          
end