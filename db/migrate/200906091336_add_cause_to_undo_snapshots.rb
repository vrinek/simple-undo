class AddCauseToUndoSnapshots < ActiveRecord::Migration
  def self.up
    add_column :undo_snapshots, :cause, :integer
  end

  def self.down
    remove_column :undo_snapshots, :cause
  end
end
