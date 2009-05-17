class Admin::AssetsController < Admin::AdminController

  def index
    super { @klass.parents }
  end
    
  def gallery        
    @images = Asset.parents.paginate(:conditions => "content_type LIKE '%%image%%'", :page => params[:page])
    respond_to do |format|
      format.html { 
        }
      format.js    
    end
  end

  def file_browser
    if params[:asset]
      @asset = Asset.new(params[:asset])
      @asset.save
    else
      @asset = Asset.new
    end
    render :layout => false
  end
  
  def create   
    @item = Asset.new(params[:asset])
    if @item.save                             
     redirect_to admin_assets_path
    else
      render :template => 'new'
    end
  end

  def update  
    @item = Asset.find(params[:id])
    @item.update_attributes(params[:asset])
    redirect_to admin_assets_path
  end
   
  def show
  end 
    
end