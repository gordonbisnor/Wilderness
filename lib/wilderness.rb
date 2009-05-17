class Wilderness

  THEMES_PATH = "#{RAILS_ROOT}/themes/"

    def field_names
    @klass.columns.map { |column| add_field_name(column) }
    @field_names << { :name => "Tags", :sort => false } if @klass.public_instance_methods.include?('tags')
    @field_names << { :name => "Comments", :sort => false } if @klass.public_instance_methods.include?('comments')
    field_names_for_user_specified_association_fields
    @field_names
  end

  def add_field_name column
    if !@klass.respond_to?("omit_fields") || @klass.responds_to?('omit_fields') && @klass.omit_fields.blank? || @klass.responds_to?('omit_fields') && !@klass.omit_fields.blank? && !@klass.omit_fields.include?(column.name)           


      @field_names << calculate_field_name_for(column)
    end  
  end

  SECTIONS = ['Articles','Assets','Categories','Comments','Links','Pages','Permissions','Roles','Roles Permissions','Users']

  DASHBOARD_SECTIONS = ['Articles','Assets','Categories','Comments','Links','Pages']    

  CAN_BE_ADDED_TO_MENUS =  [ 'Article', 'Page', 'Tag', 'Category',  'Asset' ]
 
  NON_EDITABLES = ['created_at','updated_at','state','activated_at','id','filename',
   'content_type','size','height','width','content']   
  
end

alias responds_to? respond_to?

Tag.class_eval do 
  
  def to_param
      "#{id}-#{name.gsub(/[^a-z0-9]+/i, '-')}"
    end

    def self.search_fields
      ['name']
    end
  
end