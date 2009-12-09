class PagesController < ApplicationController
  before_filter :get_page, :only => [:show]

  private

    def get_page                              
      begin
        id = params[:id]
        @page = Page.published.find(:first,:conditions=>["id=? OR url_slug = ? OR title = ?",id,id,id])
      rescue
      end
      @comment = Comment.new if @page and @page.open_for_comments?
    end
  
end