Given /^I have ([0-9]+) link$/ do |count|
  create_link
  Link.count.should == count.to_i
end
          
def create_link(title='Cool Link')
  Link.create!(:title => title, :url => 'http://www.google.com')
end