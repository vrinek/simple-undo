# Include hook code here
require 'undo'
ActionController::Base.send(:include, UndoHelper)
