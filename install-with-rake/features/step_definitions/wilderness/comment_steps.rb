Given /^I have no comments$/ do
  Comment.delete_all
end

Then /^I should have ([0-9]+) comment$/ do |count|
  Comment.count.should == count.to_i
end
         
         
Given /^I have ([0-9]+) comment$/ do |count|
  create_comment
  Comment.count.should == count.to_i
end
          
def create_comment                                                                 
  a = Article.first
  Comment.create!(:title => 'My Comment', :content => 'Great article!', :author => 'Rick Danger', :author_email => 'rick@rickdanger.com', :author_url => 'http://wwww.rickdanger.com', :commentable_type => 'Article', 'commentable_id' => a.id, :is_spam => false)
end         