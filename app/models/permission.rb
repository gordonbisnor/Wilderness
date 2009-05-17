class Permission < ActiveRecord::Base
  has_many :roles_permissions
  has_many :roles, :through => :roles_permissions
  class << self
    attr_accessor :omit_fields, :search_fields, :filter_options, :association_fields, :custom_views; 
  end
end
