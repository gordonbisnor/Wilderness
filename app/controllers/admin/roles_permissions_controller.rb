class Admin::RolesPermissionsController < Admin::AdminController

  def new
    @custom_form = true
    super
  end

  def edit
    @custom_form = true
    super
  end  

end