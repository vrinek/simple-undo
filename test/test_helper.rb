require 'rubygems'
require 'active_support'
require 'active_support/test_case'

require 'test/unit'
require 'rubygems'
require 'active_record'
require 'action_controller'

$:.unshift File.dirname(__FILE__) + '/../lib'
require File.dirname(__FILE__) + '/../init'
 
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")
 
# AR keeps printing annoying schema statements
$stdout = StringIO.new
 
def setup_db
  ActiveRecord::Base.logger
  ActiveRecord::Schema.define(:version => 1) do
    create_table :people do |t|
      t.column :name, :string
      t.column :birth_date, :date
      t.column :email, :string
    end
    
    create_table "undo_actions", :force => true do |t|
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "undo_snapshots", :force => true do |t|
      t.text    "dumped_changes"
      t.string  "undoable_type"
      t.integer "undoable_id"
      t.integer "cause"
      t.integer "undo_action_id"
    end
  end
end
 
def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end
 
class Person < ActiveRecord::Base
  acts_as_undoable
end
