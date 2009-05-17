# ADD A RECENT SCOPE TO ALL ITEMS
class ActiveRecord::Base
  named_scope :recent, :limit => 10, :order => 'id DESC'
end
