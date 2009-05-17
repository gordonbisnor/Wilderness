Given /^I have articles titled (.+)$/ do |titles|
  titles.split(', ').each do |title|
    create_article(title)
  end
end

Given /^I have ([0-9]+) article$/ do |count|
  create_article
  Article.count.should == count.to_i
end
          
def create_article(title='Beach')
  Article.create!(:title => title, :publish => true, :created_at => '2009-01-01 00:00:00',:user_id => 1)
end