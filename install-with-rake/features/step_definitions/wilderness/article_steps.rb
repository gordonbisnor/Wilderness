Given /^I have articles titled (.+)$/ do |titles|
  titles.split(', ').each do |title|
    Factory.create(:article, {:title => title})
  end
end

Given /^I have ([0-9]+) article$/ do |count|
  Factory.create(:article)
  Article.count.should == count.to_i
end
          
When /^I visit the admin list of articles$/ do
  visit admin_articles_path
end

When /^I visit article "([^\"]*)"$/ do |name|
  article = Article.find_by_title(name)
  visit admin_article_path(article)
end

When /^I visit the article creation page$/ do
  visit new_admin_article_path
end
