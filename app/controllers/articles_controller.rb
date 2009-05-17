class ArticlesController < ApplicationController

  def find_by_date           
    @year = params[:year] if params[:year].to_i
    @month = Date::MONTHNAMES[params[:month].to_i]
    @articles = Article.published.paginate(:page => params[:page], :per_page => @preferences[:articles_per_page], :conditions => ['YEAR(created_at) = ? AND month(created_at) = ?',params[:year],params[:month]])
    flash.now[:notice] = "Articles Posted #{@month} #{@year}"
    render :template => 'articles/index'
  end
  
  def archives
    @archives = Article.published.archives  
  end

  def index                                                      
    @articles = Article.published.paginate :page => params[:page], :per_page => @preferences[:articles_per_page], :order => 'id DESC', :include => [:comments,:category ]
    respond_to do |format|
      format.html { 
        }
      format.rss { @articles = Article.published.all(:limit=>20,:order => 'id DESC') }                                                                
    end
  end
  
  def show
    @article = Article.published.find(params[:id])
    @comment = Comment.new if @article.open_for_comments?
  end
  
end