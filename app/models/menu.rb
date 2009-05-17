class Menu < ActiveRecord::Base
  has_many :menu_items   
  class << self
    attr_accessor :omit_fields, :search_fields, :filter_options, :association_fields, :custom_views; 
  end
end