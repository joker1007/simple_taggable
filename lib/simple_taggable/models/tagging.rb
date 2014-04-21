module SimpleTaggable
  module Models
    class Tagging < ::ActiveRecord::Base
      belongs_to :tag
      belongs_to :taggable, polymorphic: true

      validates_presence_of :tag, :taggable
    end
  end
end
