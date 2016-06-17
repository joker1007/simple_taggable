require "rails/generators"

class SimpleTaggable::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../../templates', __FILE__)

  desc "This generator creates migrations for simple_taggable"
  def create_migration_file
    if ActiveRecord.version >= Gem::Version.new("5.0.0.beta")
      copy_file "create_tags_5.0.rb", "db/migrate/#{Time.now.utc.strftime("%Y%m%d%H%M%S")}_create_tags.rb"
      copy_file "create_taggings_5.0.rb", "db/migrate/#{(Time.now.utc + 1).strftime("%Y%m%d%H%M%S")}_create_taggings.rb"
    else
      copy_file "create_tags.rb", "db/migrate/#{Time.now.utc.strftime("%Y%m%d%H%M%S")}_create_tags.rb"
      copy_file "create_taggings.rb", "db/migrate/#{(Time.now.utc + 1).strftime("%Y%m%d%H%M%S")}_create_taggings.rb"
    end
  end
end
