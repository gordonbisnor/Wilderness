Given /^the following (.+) records?$/ do |factory,table|
  table.hashes.each do |hash|
    Factory(factory,hash)
  end
end

Given /^I am logged in as "([^\"]*)" with password "([^\"]*)"$/ do |username,password|
  do_login_as({:login=>username,:password=>password})
end

When /^I visit user "([^\"]*)"$/ do |username|
  user = User.find_by_login!(username)
  visit admin_user_path(user)
end

When /^I visit the users index page$/ do
  visit admin_users_path
end     

Given /^I am logged in as admin$/ do
  Factory('user',{:login=>'admin',:password=>'secret',:email=>'admin@admin.com'})
  Factory('user',{:login=>'viewer',:password=>'viewer',:email=>'viewer@viewer.com'})  
  do_login_as({:login=>'admin',:password=>'secret'})
end

def do_login_as user
  visit login_url
  fill_in "Username", :with => user[:login]
  fill_in "Password", :with => user[:password]
  click_button "Login"
end