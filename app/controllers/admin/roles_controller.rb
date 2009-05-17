class Admin::RolesController < Admin::AdminController      
  
  def edit
    @role = Role.find(params[:id])
    render :template => 'admin/wilderness/pages/edit'
  end
  
  
end