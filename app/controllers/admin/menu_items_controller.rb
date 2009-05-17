class Admin::MenuItemsController < Admin::AdminController

  def new
    @custom_form = true
    super
  end
  
  def edit
    @custom_form = true
    super
  end

  def update_item_list 
    klass = params[:model].gsub(' ','').constantize
    @items = klass.all
    render do |format|
      format.js 
    end
  end
  
end