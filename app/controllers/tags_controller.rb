class TagsController < ApplicationController

   def show
     @tag = Tag.find(params[:id])
     @articles = Article.paginate_tagged_with(@tag.name, :page => params[:page], :per_page => @preferences.articles_per_page)
     flash.now[:notice] = "Articles Tagged “#{@tag.name}”"
     render :template => 'articles/index'
   end  

end