# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] ||= "test"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'
require 'cucumber/formatter/unicode' # Comment out this line if you don't want Cucumber Unicode support
Cucumber::Rails.use_transactional_fixtures
Cucumber::Rails.bypass_rescue # Comment out this line if you want Rails own error handling 
                              # (e.g. rescue_action_in_public / rescue_responses / rescue_from)

require 'webrat'

Webrat.configure do |config|
  config.mode = :rails
end

require 'cucumber/rails/rspec'
require 'webrat/core/matchers'
require "#{Rails.root}/spec/factories"  

ContentArea.create!(:title => 'Container', :position => 1)
ContentArea.create!(:title => 'Header', :position => 2, :parent_id => 1)
ContentArea.create!(:title => 'Main', :position => 3, :parent_id => 1)
ContentArea.create!(:title => 'Footer', :position => 4, :parent_id => 3)
ContentArea.create!(:title => 'Content', :position => 5, :parent_id => 3) 
ContentArea.create!(:title => 'Footer Menu One', :css_class => 'menu', :position => 6, :parent_id => 3)
ContentArea.create!(:title => 'Footer Menu Two', :css_class => 'menu' , :position => 7, :parent_id => 3)                     
ContentBlock.create!(:title=>'Site Title', :position => 1, :content_area_id => 2)
ContentBlock.create!(:title=>'Tabs', :position => 2, :content_area_id => 2)
ContentBlock.create!(:title=>'Content', :position => 3, :content_area_id => 3)
ContentBlock.create!(:title=>'Archives', :position => 4, :content_area_id => 6)
ContentBlock.create!(:title=>'Categories', :position => 5, :content_area_id => 6)
ContentBlock.create!(:title=>'Links', :position => 6, :content_area_id => 6)
ContentBlock.create!(:title=>'Meta', :position => 7, :content_area_id => 7)
ContentBlock.create!(:title=>'RSS Feeds', :position => 8, :content_area_id => 7)
ContentBlock.create!(:title=>'Search', :position => 9, :content_area_id => 7)
ContentBlock.create!(:title=>'Tags', :position => 10, :content_area_id => 6)
ContentBlock.create!(:title=>'Pages', :position => 11, :content_area_id => 6)
ContentBlock.create!(:title=>'Wilderness Logo', :position => 12, :content_area_id => 4)