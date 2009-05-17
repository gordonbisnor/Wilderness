class MenuItem < ActiveRecord::Base
  belongs_to :menu
  belongs_to :menu_itemable, :polymorphic => true
  class << self
    attr_accessor :omit_fields, :search_fields, :filter_options, :association_fields, :custom_views; 
  end      
end
