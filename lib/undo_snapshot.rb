class UndoSnapshot < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  belongs_to :undoable, :polymorphic => true
  belongs_to :undo_action
  validates_presence_of :undo_action_id
  
  CAUSES = {
    :create => 0,
    :update => 1,
    :destroy => 2
  }
  
  def load_changes
    Marshal.load(dumped_changes)
  end
  memoize :load_changes
  
  def undo
    case CAUSES.invert[cause]
    when :create
      undoable.destroy
    when :update
      undoable.update_attributes previous_state
    when :destroy
      created = load_changes.class.new(load_changes.attributes)
      created.id = load_changes[:id]
      created.save
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
end
