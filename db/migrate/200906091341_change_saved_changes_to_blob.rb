class ChangeSavedChangesToBlob < ActiveRecord::Migration
  def self.up
    change_column :undo_snapshots, :dumped_changes, :text
  end

  def self.down
    change_column :undo_snapshots, :dumped_changes, :string
  end
end
