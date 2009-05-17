class CategoriesController < ApplicationController

  def show      
    @category = Category.find(params[:id])
    @articles = @category.articles.published.paginate :page => params[:page], :per_page => @preferences[:articles_per_page]
    flash.now[:notice] = "Articles Categorized “#{@category.title}”"
    render :template => 'articles/index'
  end

end