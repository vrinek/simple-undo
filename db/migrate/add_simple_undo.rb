class AddSimpleUndo < ActiveRecord::Migration
  def self.up
    create_table :undo_snapshots do |t|
      t.text :dumped_changes
      t.string :undoable_type
      t.integer :undoable_id
      t.integer :undo_action_id
      t.integer :cause
    end
    
    create_table :undo_actions do |t|
      t.integer :user_id
      t.timestamps
    end
    
    add_index :undo_snapshots, :undoable_id
    add_index :undo_snapshots, :undo_action_id
    add_index :undo_actions, :user_id
  end

  def self.down
    remove_index :undo_actions, :user_id
    remove_index :undo_snapshots, :undo_action_id
    remove_index :undo_snapshots, :undoable_id
    
    drop_table :undo_actions
    drop_table :undo_snapshots
  end
end
