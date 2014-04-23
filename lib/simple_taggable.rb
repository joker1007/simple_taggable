require "simple_taggable/version"

require "active_record"

require "generators/simple_taggable/install"
require "simple_taggable/tag_list"
require "simple_taggable/models/tag"
require "simple_taggable/models/tagging"

require "active_support/concern"

module SimpleTaggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, as: :taggable, class_name: "SimpleTaggable::Models::Tagging"
    has_many :tags, through: :taggings, class_name: "SimpleTaggable::Models::Tag"
  end
end
