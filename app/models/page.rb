class Page < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  named_scope :published, :conditions => { :publish => true }
  named_scope :unpublished, :conditions => { :publish => false }
  acts_as_comment_state_machine

  fires :create, :on => :create, :actor => :user
  fires :update, :on => :update, :actor => :user
  fires :destroy, :on => :destroy, :actor => :user
  
  def to_param
      "#{id}-#{title.gsub(/[^a-z0-9]+/i, '-')}"
    end

  class << self
    attr_accessor :omit_fields, :search_fields, :filter_options, :association_fields, :custom_views; 
  end

end