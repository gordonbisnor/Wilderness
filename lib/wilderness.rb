class Wilderness

  def self.human_name_for klass  
    klass.to_s.underscore.humanize.pluralize
  end

  def section_is_draftable
    Wilderness::DRAFTABLE_SECTIONS.include?(Wilderness.human_name_for @klass)
  end
 
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