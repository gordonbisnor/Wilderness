class WildernessView < Wilderness
  
  attr_reader :title, :controller_name, :associations
  
  def initialize items
    @items = items 
    @klass = items.responds_to?(:first) ? items.first.class : items.class
    @controller_name = @klass.to_s.underscore.downcase.pluralize  
    @field_names = []
    @records = []
    @associations = deduce_associations
  end
  
  def deduce_associations           
    associations = []

    test_item = @items.responds_to?(:first) ? @items.first : @items

    if test_item.responds_to?("roles")                         
      associations << 'roles'
    end
    if test_item.responds_to?('categories')
      associations << 'categories'
    end
    if test_item.responds_to?('articles')
      associations << 'articles'
    end                                  
    if test_item.responds_to?('pages')
      associations << 'pages'
    end
    if test_item.responds_to?('assets')
      associations << 'assets'
    end
    if test_item.responds_to?('comments')
      associations << 'comments'
    end         
    if test_item.responds_to?('users')
      associations << 'users'
    end   
    
    if test_item.responds_to?('content_area')
      associations << 'content_area'
    end
     
    associations
    
  end
  
  def title
    @controller_name.titlecase
  end

  def records
    if @items.responds_to?(:first)
      @records = @items.map { |item| get_values_for item }    
    else
      @records = get_values_for @items
    end
  end   
  
  def get_values_for item
    @row_values = []
    add_primary_values_for item               
    add_custom_values_for item
    { :item => item, :fields => @row_values } 
  end
    
  def add_primary_values_for item
    @klass.columns.each do |column|
      @column = column
      field_value_for item unless omitted? @column
    end  
  end
  
  def omitted? column  
    @klass.respond_to?("omit_fields") && !@klass.omit_fields.blank? && @klass.omit_fields.include?(@column.name)
  end
    
  def add_custom_values_for item
    add_tags_for item
    add_comments_for item
    add_association_fields_for item
    add_custom_methods_for item
    add_has_many_links_for item
  end
    
  def row_hash(name, value, type = :text, editable = false)
    { :name => name, :type => type, :value => value, :editable => editable }
  end
  
  def add_tags_for(item)
    @row_values << row_hash('Tags', "#{item.tag_list}") if @klass.public_instance_methods.include?('tags')
  end
  
  def add_comments_for(item)
    @row_values << row_hash('Comments', "#{item.comments.count}") if @klass.public_instance_methods.include?('comments') 
  end
    
  def add_association_fields_for item
     @klass.association_fields.each_pair do |key,value|
       unless item.send("#{key.to_s.downcase}").nil?
    	   @row_values << row_hash(key, item.send("#{key.to_s.downcase}").send(value)) 
    	else
   	   @row_values << row_hash(key, '') 
  	  end
     end if @klass.respond_to?("association_fields") && !@klass.association_fields.blank?
  end
  
  def add_custom_methods_for(item)
    if @klass.responds_to?("custom_methods") 
      @klass.custom_methods.each_pair do  |title,method|
        value = item.send(method)
        @row_values << row_hash(title, value)
      end 
    end
  end

  def add_has_many_links_for(item)
    if @klass.responds_to?("links_to_has_many_records")
      @klass.links_to_has_many_records.each do  |method| 
        title = method
        @row_values << row_hash(title, '', :has_many_link)
      end 
    end
  end

private

  def calculate_field_name_for column
      if column.name == 'category_id'
        { :name => "Category", :sort => nil }
      elsif column.type.to_s == 'boolean'
        { :name => "#{column.name.titlecase}", :sort => true }
      else
        { :name => column.name.titlecase, :sort => true }
      end          
  end  

  def field_names_for_user_specified_association_fields
    if @klass.respond_to?("association_fields") && !@klass.association_fields.blank?
      @klass.association_fields.keys.each do |header|
        @field_names << { :name => header, :sort => false }
      end 
    end
  end 

  def field_value_for item
	  if @column.name == 'filename' 
      image_field_value_for item
    elsif @column.name == 'comment_state'
      comment_state_field_value_for item
    elsif @column.name.length > 2 and @column.name[-2,2] == 'id'
      associated_record_for item
		  elsif ['string','text'].include?(@column.type.to_s)                          
		    textual_column_value(item)
		  elsif @column.type.to_s == 'integer'             
      @row_values << row_hash(@column.human_name,item.send(@column.name))
		  elsif @column.type.to_s == 'datetime' || @column.type.to_s == 'date'            
      date_field_value_for item
    elsif @column.type.to_s == 'boolean'             
      @row_values << row_hash(@column.human_name, item.send(@column.name) ? 'Yes' : 'No')
	  else                                            
      @row_values << row_hash(@column.human_name, @column.type)
	  end 
  end
  
  def textual_column_value(item)
     if !(Wilderness::NON_EDITABLE_FIELDS.include?(@column.name) || @column.type.to_s == 'text')
        @row_values <<  row_hash(@column.human_name, item.send(@column.name) || '', nil,true)
     elsif @column.type.to_s == "text" 
        @row_values <<  row_hash(@column.human_name, item.send(@column.name) || '', :text_area ,false)
	    else
        @row_values <<  row_hash(@column.human_name, item.send(@column.name) || '', nil ,false)
	    end
  end
  
  def comment_state_field_value_for item
    if item.comment_state == 'open_for_comments'   
      @row_values << row_hash(@column.human_name,'Open')
    elsif item.comment_state == 'closed_for_comments'   
      @row_values << row_hash(@column.human_name,'Open')
    elsif item.comment_state == 'disabled_for_comments'     
      @row_values << row_hash(@column.human_name,'Disabled')
    end
  end  

  def associated_record_for item
    length = @column.name.length
    if @column.name == polymorphic_field_names[:id]
      associated_record = item.send(polymorphic_field_names[:base])
    else
      associated = @column.name[0,length-3]
      associated_record = item.send(associated)
    end  
    unless associated_record.blank?                                    
      get_associated_record_value_for associated_record 
    else
      @row_values << row_hash(@column.human_name,'')
    end
  end 

  def polymorphic_field_names
    polymorphic_base = @klass.to_s.underscore + "able"
    polymorphic_id_field = polymorphic_base + "_id"
    polymorphic_type_field = polymorphic_base + "_type"
    {:base => polymorphic_base, :id => polymorphic_id_field, :type => polymorphic_type_field }
  end
  
  def get_associated_record_value_for associated_record
    begin
      value = associated_record.send('title') 
    rescue                                                      
       value = associated_record.send('name')  
    rescue
      value = ''
    end                                                                     
    unless value.blank?
      @row_values <<  row_hash(@column.human_name, value)
    else
      @row_values <<  row_hash(@column.human_name, '')
    end 
  end  
        
  def date_field_value_for item
    date = item.send(@column.name)                                 
		unless date.nil? 
      @row_values << row_hash(@column.human_name, date.to_s(:short)) 
    else
      @row_values << row_hash(@column.human_name, '') 
    end
  end  

  def image_field_value_for item
    extension = item.send(@column.name).split('.')[-1]
    if ['jpg','jpeg','gif','png'].include?(extension)   
      @row_values << row_hash(@column.human_name, item.public_filename(:thumb), :image)
    elsif extension == 'pdf'  
      @row_values << row_hash(@column.human_name, 'wilderness/icons/pdf.png', :image)
    elsif extension == 'xls'
      @row_values << row_hash(@column.human_name, 'wilderness/icons/excel.png', :image)
    elsif extension == 'doc'
      @row_values << row_hash(@column.human_name, 'wilderness/icons/word.png', :image)
    elsif extension == 'mp3'
      @row_values << row_hash(@column.human_name, 'wilderness/icons/sound.png', :image)
    elsif ['flv','mp4','avi','mov','mpg'].include?(extension)   
      @row_values << row_hash(@column.human_name, 'wilderness/icons/film.png', :image)
    else
      @row_values << row_hash(@column.human_name, 'wilderness/icons/disk.png', :image)
    end
  end  
    
end