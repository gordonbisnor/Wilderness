class SearchController < ApplicationController

  def index     
    search = params[:value]
    @articles = Article.paginate(:per_page => @preferences[:articles_per_page], :page => params[:page], :conditions => ['title LIKE ?',"%%#{search}%%"])
    flash.now[:notice] = "Search Results For “#{params[:value]}”"
    render :template => 'articles/index'
  end

end