class UndoAction < ActiveRecord::Base
  belongs_to :user
  has_many :undo_snapshots
  validates_presence_of :user_id
  
  named_scope :by_user, lambda {|user|
    { :conditions => { :user_id => user.id } }
  }
    
  def undo
    unless undo_snapshots.empty?
      undo_snapshots.each{ |snap|
        snap.undo
      }
      
      destroy
    else
      raise 'No snapshots to go back to'
    end
  end
end
