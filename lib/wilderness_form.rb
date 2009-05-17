class WildernessForm < Wilderness

  def initialize item  
    @klass = item.class
  end
  
  def fields
    @fields = []
    @klass.columns.map { |column| add_to_fields column }                                                                 
    if @klass.first.methods.include?('tag_list')
      @fields << {:name => 'tag_list', :type => 'string' }
    end
    return @fields
  end                  
  
  def add_to_fields column
    # MAYBE THEY SHOULD BE ALLOWED TO EDIT CREATED AT AND UPDATED AT AND USER? I DUNNO
    unless ['id','created_at','updated_at','state','user_id','comment_state'].include?(column.name)
      if column.name[-2,2] == 'id' # and column.name != 'parent_id'
        length = column.name.length 
        if column.name == 'parent_id'
          klass = @klass
        else
          klass = column.name[0,length-3].camelize.constantize
        end
        @fields << {:name => column.name, :type => 'collection', :klass => klass }
      else
        @fields << {:name => column.name, :type => column.type.to_s }
      end
    end
  end

end