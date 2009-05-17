class Category < ActiveRecord::Base
  has_many :articles
      
  def to_param
      "#{id}-#{title.gsub(/[^a-z0-9]+/i, '-')}"
  end

  class << self
    attr_accessor :omit_fields, :search_fields, :filter_options, :association_fields, :custom_views; 
  end
  
end