xml.instruct! :xml, :version=>"1.0" 
xml.rss :version=>"2.0" do
  xml.channel do
    xml.title @preferences.site_name
    xml.description "#{@preferences.site_name} Comments"
    xml.link formatted_articles_url(:rss)
    xml.language('en-us')
      @comments.each do |comment|
        xml.item do
          xml.title(comment.title)
          xml.description do 
            xml.cdata! comment.content
          end
          xml.pubDate comment.created_at.strftime("%a, %d %b %Y %H:%M:%S %z")
          xml.link "#{polymorphic_path(comment.item)}#comment_#{comment.id}"
          xml.guid "#{polymorphic_path(comment.item)}#comment_#{comment.id}"
        end
      end                
  end
end