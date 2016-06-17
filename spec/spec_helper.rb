$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "coveralls"
Coveralls.wear!

require "active_record"

case ENV["DB"]
when "postgres"
  require "pg"
  ActiveRecord::Base.establish_connection(
    adapter: "postgresql",
    database: "simple_taggable",
    username: "postgres"
  )
when "mysql"
  require "mysql2"
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

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec

    with.library :active_record
    with.library :active_model
  end
end

RSpec.configure do |config|
  config.order = :random

  config.include(Shoulda::Matchers::ActiveModel)
  config.include(Shoulda::Matchers::ActiveRecord)

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

  config.after(:suite) do
    ActiveRecord::Base.connection.execute("drop table schema_migrations")
    ActiveRecord::Base.connection.execute("drop table users")
    ActiveRecord::Base.connection.execute("drop table taggings")
    ActiveRecord::Base.connection.execute("drop table tags")
  end
end
