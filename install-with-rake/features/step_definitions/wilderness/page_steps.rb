Given /^I have pages titled (.+)$/ do |titles|
  titles.split(', ').each do |title|
    create_page(title)
  end
end

Given /^I have ([0-9]+) page$/ do |count|
  create_page
  Page.count.should == count.to_i
end
                
def create_page(title='Safari')
  Page.create!(:title => title, :publish => true)
end