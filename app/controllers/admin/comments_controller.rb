class Admin::CommentsController < Admin::AdminController
  
  def unmarked
    @comments = Comment.unmarked.paginate :page => params[:page]
    Comment.mark_as_read @comments 
  end

  def mark_as_spam   
    update_spam_status 'spam'
  end  
  
  def update_spam_status   status
      boolean = status == 'spam' ? 1 : 0                       
      conditions = "id IN(#{@ids})"
      @items = @klass.update_all( "is_spam = #{boolean}",conditions)
      @items = @klass.find(:all, :conditions=>conditions)
      if status == 'spam'
      @items.map { |comment| comment.spam! }
      else  
        @items.map { |comment| comment.ham! }
      end
        respond_to do |format|
          format.html { redirect_to "/admin/#{controller_name}" }
          format.js { 
            @item_type = @klass.to_s.downcase
            @column = 'is_spam'
            @status = status == 'spam' ? 'Yes' : 'No'
            render :template => 'admin/partials/update_column_status'
            }                             
        end
  end

  def mark_as_ham     
    update_spam_status 'ham'
  end
  
end