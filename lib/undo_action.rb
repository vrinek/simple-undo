=begin rdoc
  Undo actions belong to a user (you need to have a User model) and have many snaphots (one for each recorded change during the action).
=end
class UndoAction < ActiveRecord::Base
  MAX_UNDO_LIMIT = 1
  
  belongs_to :user
  has_many :undo_snapshots, :dependent => :delete_all
  validates_presence_of :user_id
  
  named_scope :by_user, lambda {|user|
    { :conditions => { :user_id => user.id } }
  }
  
  after_create :keep_max_undo_limit

=begin rdoc
  Undoes the changes described by its snapshots. When done it destroys the UndoAction.
=end    
  def undo
    undo_snapshots.each{ |snap|
      snap.undo
    }
    
    destroy
  end
  
  def keep_max_undo_limit
    while UndoAction.by_user(user).count > MAX_UNDO_LIMIT
      UndoAction.by_user(user).first.destroy
    end
  end
end
