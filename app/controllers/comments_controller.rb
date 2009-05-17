class CommentsController < ApplicationController
  before_filter :spam_check?, :except => :index
  
  def index
    respond_to do |format|
      format.rss { @comments = Comment.ham.all(:limit => 20,:order => 'id DESC') }                                                                
    end
  end
  
  def create
    @comment = Comment.new(params[:comment])
    if @comment.save                        
      flash[:notice] = "Comment created"
      redirect_back_or root_path
    end
  end
   
  private

    def spam_check?
        unless RAILS_ENV == 'test' || @preferences[:disable_spam_check] == 'Yes'   
          Rakismet.const_set("KEY", @preferences[:spam_check_api_key])
          Rakismet.const_set("URL", @preferences[:site_url])
          CommentsController::has_rakismet 
        else      
          Comment.disable_spam_check = true
        end
    end
  
end