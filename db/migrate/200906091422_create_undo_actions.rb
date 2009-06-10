class CreateUndoActions < ActiveRecord::Migration
  def self.up
    create_table :undo_actions, :force => true do |t|
      t.integer :user_id
      t.timestamps
    end
    
    remove_column :undo_snapshots, :snapped_at
    remove_column :undo_snapshots, :user_id
    
    add_column :undo_snapshots, :undo_action_id, :integer
  end

  def self.down
    remove_column :undo_snapshots, :undo_action_id
    
    add_column :undo_snapshots, :user_id, :integer
    add_column :undo_snapshots, :snapped_at, :datetime

    drop_table :undo_actions
  end
end
