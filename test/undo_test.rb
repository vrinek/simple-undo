require 'test_helper'

class UndoTest < ActiveSupport::TestCase
  def setup
    setup_db
    
    @p = Person.new
    @p.name = "Jack Black"
    @p.birth_date = 20.years.ago
    @p.email = "jack@black.com"
  end

  def teardown
    teardown_db
  end
  
  test 'peeps are valid' do
    (Person.all + [@p]).each{ |p|
      assert p.valid?
    }
  end

  test 'undoing a change' do
    @p.save
    new_email = "something@else.com"
    undo_actions = UndoAction.count
    
    UndoManager.instance.user = 5
    UndoManager.instance.toggle = false
    # with the manager disabled we can do changes and not create undo actions
    
    @p.email = "some@other.mail"
    @p.save
    assert_equal undo_actions, UndoAction.count
    old_email = @p.email.clone
    
    UndoManager.instance.toggle = true
    # when we enable it, the actions are created accordingly
    
    @p.email = new_email
    @p.save
    
    assert_equal undo_actions + 1, UndoAction.count
    assert_equal new_email, @p.reload.email
    
    UndoManager.instance.toggle = false
    # we need to disable the manager to make an undo
      
    UndoAction.last.undo
    
    assert_equal undo_actions, UndoAction.count
    assert_equal old_email, @p.reload.email
  end
end
