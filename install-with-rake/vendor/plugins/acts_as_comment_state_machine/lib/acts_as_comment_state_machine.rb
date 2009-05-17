# ActsAsCommentStateMachine
module ActiveRecord #:nodoc:
  module Acts #:nodoc:
    module CommentStates #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        def acts_as_comment_state_machine
          require 'aasm'
          include AASM    
          
          has_many :comments, :as => :commentable, :order => 'id DESC'  
          
          aasm_column :comment_state
          aasm_initial_state :open_for_comments
          aasm_state :open_for_comments
          aasm_state :closed_for_comments
          aasm_state :disabled_for_comments

          aasm_event :open_to_comments do
            transitions :from => [:open_for_comments,:closed_for_comments,:disabled_for_comments], :to => :open_for_comments
          end

          aasm_event :close_to_comments do
            transitions :from => [:open_for_comments,:closed_for_comments,:disabled_for_comments], :to => :closed_for_comments
          end

          aasm_event :disable_comments do
            transitions :from => [:open_for_comments,:closed_for_comments,:disabled_for_comments], :to => :disabled_for_comments
          end                       
          
          include ActiveRecord::Acts::CommentStates::InstanceMethods
#          extend ActiveRecord::Acts::CommentStates::SingletonMethods
          
        end
      end         
      
   private

      module InstanceMethods
      end
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::Acts::CommentStates)