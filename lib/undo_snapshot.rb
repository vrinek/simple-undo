class UndoSnapshot < ActiveRecord::Base
  belongs_to :undoable, :polymorphic => true
  belongs_to :undo_action
  validates_presence_of :undo_action_id
  
  CAUSES = {
    :create => 0,
    :update => 1,
    :destroy => 2
  }
  
  def load_changes
    Marshal.load(ActiveSupport::Base64.decode64(dumped_changes))
  end
  
  def undo
    case CAUSES.invert[cause]
    when :create
      undoable.destroy
    when :update
      save_to undoable, previous_state
    when :destroy
      created = load_changes.class.new
      save_to created, load_changes.attributes
    end
    
    destroy
  end
  
  def previous_state
    state = {}
    load_changes.keys.each{|k|
      state[k] = load_changes[k][0]
    }
    return state
  end
  
  def save_to(this, attributes)
    attributes.keys.each{ |atr|
      this.send(atr + '=', attributes[atr])
    }
    this.save
  end
end
