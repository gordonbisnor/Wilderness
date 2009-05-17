class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true           
  belongs_to :item, :class_name => 'commentable_type', :foreign_key => 'commentable_id'
  belongs_to :user
  fires :create, :on => :create, :actor => :user
  fires :update, :on => :update, :actor => :user
  fires :destroy, :on => :destroy, :actor => :user
  
  @@disable_spam_check = false
  class << self; attr_accessor :disable_spam_check; end

  class << self
    attr_accessor :omit_fields, :search_fields, :filter_options, :association_fields, :custom_views; 
  end
      
  validates_presence_of :content
  validates_presence_of :commentable_type
  validates_presence_of :commentable_id
  validates_presence_of :author_email
  validates_presence_of :author
  
  before_create :is_it_spam?

  named_scope :unmarked, :conditions => { :marked => false }
  named_scope :marked, :conditions => { :marked => true }
  named_scope :ham, :conditions => { :is_spam => false }
  named_scope :spam, :conditions => { :is_spam => true }
  
  def is_it_spam?
    if RAILS_ENV == 'test' || Comment.disable_spam_check == true
      self.is_spam = false
    else
      Comment::has_rakismet
      self.is_spam = true if self.spam?  
    end                                  
    true # RETURN TRUE REQUIRED (FOR CUCUMBER AT LEAST)
  end

  def self.mark_as_read comments
    ids = comments.map(&:id).join(',')
    Comment.update_all( "marked = 1", "id IN (#{ids})" ) unless ids.blank?
  end
   
  def item
    self.commentable_type.constantize.find(commentable_id)
  end 
    
end