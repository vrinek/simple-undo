require 'test_helper'

class ActsAsUndoableTest < ActiveSupport::TestCase
  def setup
    setup_db
  end

  def teardown
    teardown_db
  end
end
