xml.instruct! :xml, :version=>"1.0" 
xml.rss :version=>"2.0" do
  xml.channel do
    xml.title @preferences[:site_name]
    xml.description "#{@preferences[:site_name]} Articles"
    xml.link formatted_articles_url(:rss)
    xml.language('en-us')
      @articles.each do |article|
        xml.item do
          xml.title(article.title)
          xml.description do 
            xml.cdata! article.content
          end
          xml.pubDate article.created_at.strftime("%a, %d %b %Y %H:%M:%S %z")
          xml.link article_url(article)
          xml.guid article_url(article)
        end
      end                
  end
end