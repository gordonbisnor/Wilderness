class WildernessMigration < ActiveRecord::Migration
  def self.up

    # TIMELINE
    create_table :timeline_events do |t|
      t.string   :event_type, :subject_type,  :actor_type,  :secondary_subject_type
      t.integer               :subject_id,    :actor_id,    :secondary_subject_id
      t.timestamps
    end

    # ARTICLES
    create_table :articles do |t|
      t.string :title
      t.string :url_slug
      t.text :content
      t.boolean :publish, :default => false    
      t.integer :user_id  
      t.integer :category_id, :default => 1
      t.string :comment_state, :null => false, :default => 'open_for_comments'      
      t.integer :position
      t.timestamps
    end

    Article.create(:title => 'Welcome To WildernessCMS',:content => 'Welcome To WildernessCMS, this is a default article. To login, use the Bort default user: admin/chester',:publish => true,:user_id => 1)

    
    # ASSETS
    create_table :assets do |t|
      t.string :filename 
      t.string :title   
      t.integer :size
      t.string :content_type
      t.integer :height       
      t.integer :width
      t.integer  :parent_id
      t.string :thumbnail
      t.string :assetable_type
      t.integer :assetable_id    
      t.integer :category_id, :default => 1
      t.integer :position
      t.timestamps
    end

    # CATEGORIES
    create_table :categories do |t|
      t.string :title
      t.integer :position
      t.timestamps
    end
    Category.create(:title => 'Uncategorized')

    # COMMENTS
    create_table :comments, :force => true do |t|
       t.integer :commentable_id, :default => 0
       t.string :commentable_type, :limit => 15, :default => ""
       t.string :title, :default => ""
       t.text :content, :default => ""
       t.integer :user_id, :default => 0, :null => false
       t.string :author
       t.string :author_url
       t.string :author_email
       t.string :comment_type, :default => 'comment'
       t.string :permalink   
       t.string :user_ip
       t.string :user_agent
       t.string :referrer
       t.integer :parent_id  
       t.boolean :is_spam, :default => false
       t.boolean :marked, :default => false
       t.timestamps
     end
     add_index "comments", "user_id"
     add_index "comments", "commentable_id"
     
     # CONTENT AREAS
    create_table :content_areas do |t|
      t.string :title
      t.string :css_class
      t.integer :parent_id 
      t.integer :position
      t.timestamps
    end
    ContentArea.create(:title => 'Container', :position => 1)
    ContentArea.create(:title => 'Header', :position => 2, :parent_id => 1)
    ContentArea.create(:title => 'Main', :position => 3, :parent_id => 1)
    ContentArea.create(:title => 'Footer', :position => 4, :parent_id => 3)
    ContentArea.create(:title => 'Content', :position => 5, :parent_id => 3) 
    ContentArea.create(:title => 'Footer Menu One', :css_class => 'menu', :position => 6, :parent_id => 3)
    ContentArea.create(:title => 'Footer Menu Two', :css_class => 'menu' , :position => 7, :parent_id => 3)

    # CONTENT BLOCKS
    create_table :content_blocks do |t|
      t.string :title
      t.integer :content_area_id
      t.integer :position
      t.timestamps
    end
    ContentBlock.create(:title=>'Site Title', :position => 1, :content_area_id => 2)
    ContentBlock.create(:title=>'Tabs', :position => 2, :content_area_id => 2)
    ContentBlock.create(:title=>'Content', :position => 3, :content_area_id => 3)
    ContentBlock.create(:title=>'Archives', :position => 4, :content_area_id => 6)
    ContentBlock.create(:title=>'Categories', :position => 5, :content_area_id => 6)
    ContentBlock.create(:title=>'Links', :position => 6, :content_area_id => 6)
    ContentBlock.create(:title=>'Meta', :position => 7, :content_area_id => 7)
    ContentBlock.create(:title=>'RSS Feeds', :position => 8, :content_area_id => 7)
    ContentBlock.create(:title=>'Search', :position => 9, :content_area_id => 7)
    ContentBlock.create(:title=>'Tags', :position => 10, :content_area_id => 6)
    ContentBlock.create(:title=>'Pages', :position => 11, :content_area_id => 6)
    ContentBlock.create(:title=>'Wilderness Logo', :position => 12, :content_area_id => 4)

    # LINKS
    create_table :links do |t|
      t.string :title
      t.string :url    
      t.integer :category_id, :default => 1
      t.integer :position
      t.timestamps
    end

    # MENUS
    create_table :menus do |t|
      t.string :title
      t.integer :position
      t.timestamps
    end
    Menu.create(:title=>'Main Menu')
    
    # MENU ITEMS
    create_table :menu_items do |t|
      t.integer :menu_id
      t.string :menu_itemable_type
      t.integer :menu_itemable_id
      t.integer :position
      t.timestamps
    end

    # PAGES
    create_table :pages do |t|
      t.string :title
      t.string :url_slug
      t.text :content
      t.boolean :publish, :default => false
      t.integer :user_id  
      t.integer :category_id, :default => 1 
      t.string :comment_state, :null => false, :default => 'open_for_comments'      
      t.integer :position
      t.timestamps
    end  

    # PERMISSIONS
    create_table :permissions do |t|
      t.string :title
      t.timestamps
    end
    Permission.create (:title => 'all')
    Permission.create (:title => 'index')
    Permission.create (:title => 'show')
    Permission.create (:title => 'new')
    Permission.create (:title => 'edit')
    Permission.create (:title => 'create')
    Permission.create (:title => 'update')
    Permission.create (:title => 'destroy')
    Permission.create (:title => 'delete_checked')
    Permission.create (:title => 'mark_as_spam')
    Permission.create (:title => 'mark_as_ham')
    Permission.create (:title => 'publish')
    Permission.create (:title => 'unpublish')
    Permission.create (:title => 'search')
    Permission.create (:title => 'dashboard')
    Permission.create (:title => 'open_for_comments')
    Permission.create (:title => 'close_for_comments')
    Permission.create (:title => 'disable_comments')

    # ROLES PERMISSIONS
    create_table :roles_permissions do |t|
      t.integer :role_id
      t.integer :permission_id
      t.string :section
      t.boolean :active, :default => false
      t.timestamps
    end
    RolesPermission.create do |r|
      r.section = 'All'
      r.permission_id = 1
      r.role_id = 1
    end                                

    # PREFERENCES
    create_table :preferences do |t|
      t.string :title
      t.string :setting
      t.timestamps
    end 
    Preference.create (:title => 'site_name',:setting=>'WildernessCMS')
    Preference.create (:title => 'use_comment_gravatars',:setting=>'Yes')
    Preference.create (:title => 'publish_articles_by_default',:setting=>'Yes')
    Preference.create (:title => 'site_url',:setting=>'http://localhost:3000')
    Preference.create (:title => 'excerpt_length',:setting=>'500')
    Preference.create (:title => 'disable_spam_check',:setting=>'Yes')
    Preference.create (:title => 'default_category',:setting=>'Uncategorized')
    Preference.create (:title => 'articles_per_page',:setting=>'20')
    Preference.create (:title => 'spam_check_api_key',:setting=>'')
    Preference.create (:title => 'number_of_items_to_include_in_rss_feeds',:setting=>'10')
    Preference.create (:title => 'sortable_sections',:setting=>'Menu Items,Content Areas,Content Blocks')
    Preference.create (:title => 'text_editor',:setting=>"TinyMCE")
    
    # TAGS
    create_table :tags do |t|
      t.column :name, :string
    end 
    create_table :taggings do |t|
      t.column :tag_id, :integer
      t.column :taggable_id, :integer
      # You should make sure that the column created is
      # long enough to store the required class names.
      t.column :taggable_type, :string
      t.column :created_at, :datetime
    end                                  
    add_index :taggings, :tag_id
    add_index :taggings, [:taggable_id, :taggable_type]
    
  end
  
  def self.down   
    drop_table :articles 
    drop_table :assets
    drop_table :categories
    drop_table :content_areas
    drop_table :content_blocks
    drop_table :comments  
    drop_table :links  
    drop_table :menus
    drop_table :menu_items
    drop_table :pages 
    drop_table :permissions
    drop_table :preferences
    drop_table :roles_permissions
    drop_table :taggings
    drop_table :tags
    drop_table :timeline_events
  end
  
end