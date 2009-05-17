class WildernessController < ActionController::Base
  include AuthenticatedSystem
  include RoleRequirementSystem
  filter_parameter_logging :password, :password_confirmation
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  
  before_filter :get_klass
  before_filter :get_preferences
  before_filter :set_sortable_sections_default_scopes
  before_filter :get_menu_items
  before_filter :get_content_areas
  
  def get_content_areas
    @content_areas = ContentArea.all(:conditions => 'parent_id IS NULL', :order => 'position ASC', :include => :content_blocks)
  end
    
  # THIS IS NOT IN USE YET, MAYBE SHOULD BE DISCARDED IF NOT GOING TO USE
  def get_theme    
    theme = @preferences[:theme]
    @theme = YAML::load(File.open("#{Wilderness::THEMES_PATH}/#{theme}/info.yml")).symbolize_keys!
  end
  
  def get_menu_items
    @pages = Page.all
    @tags = Tag.all
    @categories = Category.all
    @links = Link.all
    @archives = Article.archives
    @main_menu = get_main_menu
  end
    
  def get_main_menu                            
    @menu = Menu.first
    @menu.menu_items.all unless @menu.blank?
  end

    def get_klass   
      klass_name = controller_name.to_s.singularize.titlecase.gsub(' ','')
      begin
        if Kernel.const_get(klass_name)
          @klass = klass_name.constantize
        end
      rescue
        @klass = nil
      end
    end   

    def redirect_back_or(path)
      redirect_to :back
      rescue ActionController::RedirectBackError
      redirect_to root_path
    end
   
    def get_preferences
      @preferences = {}
      preferences = Preference.all
      preferences.each do |preference|
        @preferences[preference.title.to_sym] = preference.setting
      end  
      @sortable_sections = sortable_sections
    end
    
    def sortable_sections               
      if @preferences[:sortable_sections]
        @preferences[:sortable_sections].split(',').map(&:chomp).map { |m| m.gsub(" ","") }.map(&:singularize).map(&:constantize)  
      else
        []
      end
    end
   
    def set_sortable_sections_default_scopes
      @sortable_sections.each do |section|
        section.class_eval do
          default_scope :order => 'position ASC'
        end 
      end
    end

    protected

    # Automatically respond with 404 for ActiveRecord::RecordNotFound
    def record_not_found
      render :file => File.join(RAILS_ROOT, 'public', '404.html'), :status => 404
    end
  
end