class Admin::PreferencesController < Admin::AdminController
  
  def index   
    @prefs = Preference.all
    render :template => 'admin/preferences/index' 
  end
  
  def adjust
    params[:preferences].each_pair do |record,value|
      Preference.find_by_title(record).update_attribute(:setting,value)
    end
    flash[:notice] = 'Preferences Updated'
    redirect_to admin_preferences_path
  end
  
end