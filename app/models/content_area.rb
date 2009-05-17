class ContentArea < ActiveRecord::Base
  acts_as_tree
  has_many :content_blocks
  class << self
    attr_accessor :omit_fields, :search_fields, :filter_options, :association_fields, :custom_views; 
   end
end
