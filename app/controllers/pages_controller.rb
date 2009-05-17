class PagesController < ApplicationController
  before_filter :get_page, :only => [:show]

  private

    def get_page                              
      begin
        @page = Page.published.find(params[:id])
      rescue
        @page = Page.published.find_by_title(params[:id])
      end
      @comment = Comment.new if @page and @page.open_for_comments?
    end
  
end