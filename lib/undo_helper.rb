module UndoHelper

  def self.included (base)
    base.extend(UndoMethods)
  end
  
  module UndoMethods
    def undo_methods
      include InstanceMethods
    end
  end
  
  module InstanceMethods
    def snap(&block)
      UndoManager.instance.action = nil
      UndoManager.instance.user = @logged_user
      UndoManager.instance.toggle = true
      
      block.call
      
      UndoManager.instance.toggle = false
    end
  end
end