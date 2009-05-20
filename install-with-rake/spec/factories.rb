Factory.define :user do |f|  
  f.login "foo"  
  f.password "foobar"  
  f.password_confirmation { |u| u.password }  
  f.email "foo@example.com"  
  f.state  'active'   
end

Factory.define :role do |f|
  f.name "admin"
end

Factory.define :permission do |f|
  f.title "all"
end

Factory.define :roles_permission do |f|
  f.role_id 1
  f.permission_id 1
end  

Factory.define :article do |f|
  f.title "Beach"  
  f.content "Beach"
  f.publish true
  f.created_at '2009-01-01 00:00:00'
  f.user_id 1
end