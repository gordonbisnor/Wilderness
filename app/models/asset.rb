class Asset < ActiveRecord::Base
  belongs_to :assetable, :polymorphic => true           
    
  has_attached_file :attachment, :styles => { :thumb=> "50x50#" }
       
   def size
     "#{super / 1024}k" unless super.blank?
   end
      
   class << self
     attr_accessor :omit_fields, :search_fields, :filter_options, :association_fields, :custom_views; 
   end
           
end