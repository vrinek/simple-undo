class UndoManager
  include Singleton
  
  attr_accessor :user, :toggle, :action
  
  def snap(this, cause)
    if @toggle
      @action ||= UndoAction.create(:user_id => (@user.is_a?(Integer) ? @user : @user.try(:id)))
      this.save_snapshot :cause => cause, :undo_action => @action
    end
  end
  
  def on
    self.toggle = true
  end
  
  def off
    self.toggle = false
  end
end
