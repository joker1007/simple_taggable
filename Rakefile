require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :test do
  desc "copy migrations to spec/db/migrate"
  task :copy_migrations => "spec/db/migrate" do
    cp "lib/generators/templates/create_tags.rb", "spec/db/migrate/1_create_tags.rb"
  end

  directory "spec/db/migrate"
end
