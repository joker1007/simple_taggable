require 'spec_helper'

describe SimpleTaggable::Models::Tagging do
  it "is created given tag" do
    tag = SimpleTaggable::Models::Tag.create!(name: "タグ")
    SimpleTaggable::Models::Tagging.create!(tag: tag)
    expect(SimpleTaggable::Models::Tagging.first.tag).to eq tag
  end
end
