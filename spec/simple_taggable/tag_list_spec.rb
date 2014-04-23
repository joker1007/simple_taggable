require 'spec_helper'

describe SimpleTaggable::TagList do
  it "is Enumerable" do
    expect(subject.class.ancestors).to include(Enumerable)
    expect(subject).to be_respond_to(:each)
  end

  let(:tag_list) { SimpleTaggable::TagList.new }

  describe "Constructor" do
    it "should receive initial tags" do
      tag_list = SimpleTaggable::TagList.new("init1", "init2")
      expect(tag_list.length).to eq(2)
    end
  end

  describe "#add" do
    it "should add one tag" do
      expect { tag_list.add("Tag1") }
        .to change { tag_list.length }.from(0).to(1)
    end

    it "should receive multi tags" do
      expect { tag_list.add("Tag1", "Tag2") }
        .to change { tag_list.length }.from(0).to(2)
    end

    it "should not change if added duplicate tag" do
      tag_list.add("Tag1")
      expect { tag_list.add("Tag1") }
        .not_to change { tag_list.length }
    end
  end

  describe "Index access" do
    it "should return tag string" do
      tag_list.add("Tag1")
      expect(tag_list[0]).to eq "Tag1"
    end
  end

  describe "Filtering" do
    context "Given filters return false" do
      it "filter out tags" do
        tag_list = SimpleTaggable::TagList.new(filters: [
          ->(_, tag) { tag != "NoAdd" }
        ])

        tag_list.add("Tag1", "NoAdd")
        expect(tag_list).to match_array(["Tag1"])
      end
    end

    it "should receive multi filters" do
      tag_list = SimpleTaggable::TagList.new(filters: [
        ->(_, tag) { tag != "NoAdd" },
        ->(tl, tag) { tl.length < 2 },
      ])

      tag_list.add("Tag1", "NoAdd", "Tag2", "Tag3")
      expect(tag_list).to match_array(["Tag1", "Tag2"])
    end
  end

  describe "Converting" do
    it "convert added tag" do
      tag_list = SimpleTaggable::TagList.new(converters: [
        ->(_, tag) { tag.upcase },
        ->(_, tag) { tag[0..1] },
      ])

      tag_list.add("foo", "bar", "baz")
      expect(tag_list).to match_array(["FO", "BA"])
    end

    it "convert tag before filter" do
      tag_list = SimpleTaggable::TagList.new(
        filters: [
          ->(_, tag) { tag =~ /_1\Z/ },
        ],
        converters: [
          ->(_, tag) { tag + "_1" },
        ],
      )

      tag_list.add("foo")
      expect(tag_list).to match_array(["foo_1"])
    end
  end
end
