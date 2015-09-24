$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "coveralls"
Coveralls.wear!

require "active_record"

case ENV["DB"]
when "postgres"
  ActiveRecord::Base.establish_connection(
    adapter: "pg",
    database: "simple_taggable",
    username: "postgres"
  )
when "mysql"
  ActiveRecord::Base.establish_connection(
    adapter: "mysql2",
    database: "simple_taggable",
    username: "root"
  )
else
  ActiveRecord::Base.establish_connection(
    adapter: "sqlite3",
    database: ":memory:"
  )
end

require 'simple_taggable'

# Test Class
class User < ActiveRecord::Base
  include SimpleTaggable
end

ActiveRecord::Migration.verbose = false
ActiveRecord::Migrator.migrate File.expand_path("../db/migrate", __FILE__), nil

I18n.enforce_available_locales = false # suppress warning

require 'database_cleaner'
require "shoulda-matchers"

RSpec.configure do |config|
  config.order = :random

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
