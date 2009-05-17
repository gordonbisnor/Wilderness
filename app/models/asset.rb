class Asset < ActiveRecord::Base
  belongs_to :assetable, :polymorphic => true           
  named_scope :parents, :conditions => 'parent_id IS NULL'
  named_scope :thumbs, :conditions => { :thumbnail => 'thumb' }
  
  has_attachment :storage => :file_system,
    :thumbnails => { :thumb => [50, 50] }
      
   attr_accessible :title, :category_id 
   
   def size
     "#{super / 1024}k" unless super.blank?
   end
   
   def dimensions
     "#{width} x #{height} pixels"
   end         

   class << self
     attr_accessor :omit_fields, :search_fields, :filter_options, :association_fields, :custom_views; 
   end
           
end