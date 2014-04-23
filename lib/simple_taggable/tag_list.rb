require "active_support/core_ext/module/delegation"

module SimpleTaggable
  class TagList
    include Enumerable

    delegate \
      :[],
      :each,
      :length,
      :size,
      :count,
      :include?,
      :clear,
      to: :raw_data

    def initialize(*tags, filters: [], converters: [])
      @raw_data = []

      @filters = filters.freeze
      @converters = converters.freeze

      tags.flatten.each {|tag| add(tag) }
    end

    def add(*tags)
      tags.flatten.each do |t|
        tag = @converters.inject(t.to_s) do |pre_tag, converter|
          converter.call(self, pre_tag)
        end

        if @filters.all? { |filter| filter.call(self, tag) }
          @raw_data << tag
        end
      end
      @raw_data.uniq!

      self
    end
    alias :<< :add

    def to_a
      @raw_data
    end

    private

    def raw_data
      @raw_data
    end
  end
end
