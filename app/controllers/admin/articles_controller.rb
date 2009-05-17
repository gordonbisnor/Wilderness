class Admin::ArticlesController < Admin::AdminController
  before_filter :get_article_preferences

private

  def get_article_preferences
    if @preferences[:publish_articles_by_default] == "Yes"
      Article.publish_articles_by_default = true
    end  
  end
    
end