=begin rdoc
  Undo actions belong to a user (you need to have a User model) and have many snaphots (one for each recorded change during the action).
=end
class UndoAction < ActiveRecord::Base
  belongs_to :user
  has_many :undo_snapshots, :dependent => :delete_all
  validates_presence_of :user_id
  
  named_scope :by_user, lambda {|user|
    { :conditions => { :user_id => user.id } }
  }

=begin rdoc
  Undoes the changes described by its snapshots. When done it destroys the UndoAction.
=end    
  def undo
    undo_snapshots.each{ |snap|
      snap.undo
    }
    
    destroy
  end
end
