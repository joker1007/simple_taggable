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
    has_many :taggings, as: :taggable, class_name: "SimpleTaggable::Models::Tagging", dependent: :destroy
    has_many :tags, through: :taggings, class_name: "SimpleTaggable::Models::Tag"

    scope :tagged_with, ->(*tag_name, match_all: false, exclude: false) {
      raise "`tagged_with` cannot use :match_all and :exclude at the same time" if match_all && exclude
      tag_scope = SimpleTaggable::Models::Tag.where(name: tag_name)

      if exclude
        users = User.joins(:tags).merge(tag_scope).group(%W("#{table_name}"."id"))
        where.not(id: users.pluck(:id))
      else
        User.joins(:tags).merge(tag_scope).group(%W("#{table_name}"."id")).tap do |scope|
          break scope.having("count(*) = ?", tag_name.length) if match_all
        end
      end
    }

    after_save :__sync_tags__
  end

  module ClassMethods
    def inherited(child)
      super
      child.instance_variable_set("@__tag_filters__", __tag_filters__.dup)
      child.instance_variable_set("@__tag_converters__", __tag_converters__.dup)
    end

    def add_tag_filter(filter_proc, &block)
      pr = filter_proc || block
      self.__tag_filters__ << pr
    end

    def reset_tag_filters
      __tag_filters__.clear
    end

    def add_tag_converter(converter_proc, &block)
      pr = converter_proc || block
      self.__tag_converters__ << pr
    end

    def reset_tag_converters
      __tag_converters__.clear
    end

    # internal
    def __tag_filters__
      @__tag_filters__ ||= []
      @__tag_filters__
    end

    # internal
    def __tag_converters__
      @__tag_converters__ ||= []
      @__tag_converters__
    end
  end

  def tag_list
    @tag_list ||= SimpleTaggable::TagList.new(
      tags.pluck(:name),
      filters: self.class.__tag_filters__,
      converters: self.class.__tag_converters__,
    )
  end

  def tag_list=(tag_list)
    case tag_list
    when TagList, Array, String
      @tag_list = SimpleTaggable::TagList.new(
        tag_list,
        filters: self.class.__tag_filters__,
        converters: self.class.__tag_converters__,
      )
    else
      raise TypeError.new("tag_list is not TagList object")
    end
  end

  private

  def __sync_tags__
    current_tags = tags.to_a
    tags = tag_list.map do |tag_name|
      SimpleTaggable::Models::Tag.find_or_initialize_by(name: tag_name)
    end
    new_tags = tags - current_tags
    old_tags = current_tags - tags

    self.tags << new_tags
    taggings.where(tag_id: old_tags.map(&:id)).destroy_all
  end
end
