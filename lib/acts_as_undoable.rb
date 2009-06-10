module Undone
  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    def acts_as_undoable
      send :include, InstanceMethods
      
      has_many :undo_snapshots, :as => :undoable

      alias_method :create_without_undo, :create
      alias_method :create, :create_with_undo

      alias_method :update_without_undo, :update
      alias_method :update, :update_with_undo

      alias_method :destroy_without_undo, :destroy
      alias_method :destroy, :destroy_with_undo
    end
  end

  module InstanceMethods
    def save_snapshot(options = {})
      options.stringify_keys!
      full = options['cause'] == :destroy
      
      UndoSnapshot.create(
        :dumped_changes => Marshal.dump(full ? self : self.changes),
        :undoable => self,
        :cause => UndoSnapshot::CAUSES[options['cause']],
        :undo_action => options['undo_action']
      )
      
      return true
    end

    def create_with_undo(*args)
      create_without_undo(*args)
      UndoManager.instance.snap self, :create
    end

    def update_with_undo(*args)
      UndoManager.instance.snap self, :update
      update_without_undo(*args)
    end

    def destroy_with_undo(*args)
      UndoManager.instance.snap self, :destroy
      destroy_without_undo(*args)
    end
  end
end

ActiveRecord::Base.send :include, Undone
