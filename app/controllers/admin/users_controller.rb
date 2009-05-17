class Admin::UsersController < Admin::AdminController

  def new
    @custom_form = true
    super
  end
  
  def edit
    @custom_form = true
    super
  end

  def create
    @item = @klass.new(params[@klass.to_s.underscore.downcase.to_sym])
    @item.user_id = @current_user.id if @klass.column_names.include?('user_id')
    if @item.save and @item.register! and @item.activate!    
      flash[:notice] = "#{@klass} Created"
      redirect_to [:admin,@item]
    else     
      @wilderness = WildernessForm.new(@item)                                    
      render :template => "admin/wilderness/pages/new"
    end
  end

  def update 
    if @item.update_attributes(params[@klass.to_s.downcase.to_sym].merge({:role_ids => params[@klass.to_s.downcase.to_sym][:role_ids] || []}))
      flash[:notice] = "#{@klass} Updated"
      redirect_to [:admin,@item]
    else
      render :template => 'admin/partials/edit'
    end
  end
    
end