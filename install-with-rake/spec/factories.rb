Factory.define :user do |f|  
  f.login "foo"  
  f.password "foobar"  
  f.password_confirmation { |u| u.password }  
  f.email "foo@example.com"  
  f.state  'active'
end