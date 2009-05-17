Given /^I have categories titled (.+)$/ do |titles|
  titles.split(', ').each do |title|
    create_category(title)
  end
end

Given /^I have ([0-9]+) category$/ do |count|
  create_category
  Category.count.should == count.to_i
end
          
def create_category(title='Surfing')
  Category.create!(:title => title)
end