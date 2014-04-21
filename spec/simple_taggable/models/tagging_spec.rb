require 'spec_helper'

describe SimpleTaggable::Models::Tagging do
  it { should belong_to(:tag) }
  it { should belong_to(:taggable) }

  it "is created given tag and taggable" do
    tag = SimpleTaggable::Models::Tag.create!(name: "タグ")
    user = User.create!(name: "joker1007")
    SimpleTaggable::Models::Tagging.create!(tag: tag, taggable: user)
    expect(SimpleTaggable::Models::Tagging.first.tag).to eq tag
    expect(SimpleTaggable::Models::Tagging.first.taggable).to eq user
  end

  it "is not creatable no taggable" do
    tag = SimpleTaggable::Models::Tag.create!(name: "タグ")
    tagging = SimpleTaggable::Models::Tagging.create(tag: tag)
    expect(tagging).not_to be_persisted
  end

  it "is not creatable no tag" do
    user = User.create!(name: "joker1007")
    tagging = SimpleTaggable::Models::Tagging.create(taggable: user)
    expect(tagging).not_to be_persisted
  end
end
