class CreateUndoSnapshots < ActiveRecord::Migration
  def self.up
    create_table :undo_snapshots, :force => true do |t|
      t.integer :user_id
      t.string :dumped_changes
      t.datetime :snapped_at
      t.string :undoable_type
      t.integer :undoable_id
    end
  end

  def self.down
    drop_table :undo_snapshots
  end
end
