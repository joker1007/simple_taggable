module SimpleTaggable
  module Models
    class Tag < ::ActiveRecord::Base
      validates_uniqueness_of :name

      has_many :taggings
    end
  end
end
