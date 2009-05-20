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
  role = Factory.create(:role)
  permission = Factory.create(:permission)
  Factory.create(:roles_permission, {:role_id => role.id, :permission_id => permission.id})
  user = Factory.create(:user, {:login=>'admin',:password=>'secret',:email=>'admin@admin.com'})
  RolesUser.create!(:role_id => role.id, :user_id => user.id)
  do_login_as({:login=>'admin',:password=>'secret'})
end

Given /^I am logged in as nobody special$/ do      
  role = Factory.create(:role,{:name=>'Underling'})
  user = Factory.create(:user,{:login=>'employee',:password=>'employee',:email=>'employee@employee.com'})
  RolesUser.create!(:role_id => role.id, :user_id => user.id)
  do_login_as({:login=>'employee',:password=>'employee'})
end

def do_login_as user
  visit login_url
  fill_in "Username", :with => user[:login]
  fill_in "Password", :with => user[:password]
  click_button "Login"
end