Given /^I have tags named (.+)$/ do |names|
  names.split(', ').each do |name|
    create_tag(name)
  end
end

Given /^I have ([0-9]+) tag$/ do |count|
  create_tag
  Tag.count.should == count.to_i
end
          
def create_tag(name='Fun')
  Tag.create!(:name => name)
end