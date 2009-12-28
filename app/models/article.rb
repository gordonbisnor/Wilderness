class Article < ActiveRecord::Base
  versioned
  belongs_to :category
  belongs_to :user
  before_create :publish_automatically?

  fires :create, :on => :create, :actor => :user
  fires :update, :on => :update, :actor => :user
  fires :destroy, :on => :destroy, :actor => :user
  
  acts_as_taggable 
  acts_as_comment_state_machine

  @publish_articles_by_default = false
  class << self; attr_accessor :publish_articles_by_default; end
  
  validates_uniqueness_of :url_slug, :allow_nil => true, :allow_blank => true
  
  def author_email
    user.email
  end
  
  def author
    user
  end
  
  def to_param
    if url_slug.present?
      url_slug
    elsif title.present?
      "#{id}-#{title.gsub(/[^a-z0-9]+/i, '-')}"
    else
      id.to_s
    end
  end

  class << self
    attr_accessor :omit_fields, :search_fields, :filter_options, :association_fields, :custom_views,  :show_category_filter; 
  end
                                                     
  # NEED TO INCORPORATE ASSOCIATION TYPE SO AN ARRAY OF ASSOCIATIONS, THE ASSOCIATION IS A HASH?                          
  named_scope :published, :conditions => { :publish => true }
  named_scope :unpublished, :conditions => { :publish => false }
                
  def self.archives
    self.find(:all, :select =>'DISTINCT YEAR(created_at) AS `year`, MONTHNAME(created_at) AS `month_name`, MONTH(created_at) AS month, count(id) as articles',:group=>'YEAR(created_at), MONTH(created_at)',:order => 'created_at DESC', :limit => 12)
  end

   private
   
    def publish_automatically?
      if Article.publish_articles_by_default == true
        self.publish = true
      end
    end
  
end