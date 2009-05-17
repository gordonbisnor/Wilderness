class Role < ActiveRecord::Base
  default_scope :order => 'name ASC'  
  has_and_belongs_to_many :users
  has_many :roles_permissions
  has_many :permissions, :through => :roles_permissions
  class << self
    attr_accessor :omit_fields, :search_fields, :filter_options, :association_fields, :custom_views; 
  end
end