class RolesPermission < ActiveRecord::Base
  belongs_to :role
  belongs_to :permission
  class << self
    attr_accessor :omit_fields, :search_fields, :filter_options, :association_fields, :custom_views; 
  end  
end
