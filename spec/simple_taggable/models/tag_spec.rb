require 'spec_helper'

describe SimpleTaggable::Models::Tag do
  it "is created given name" do
    described_class.create!(name: "タグ")
    expect(described_class.first.name).to eq "タグ"
  end

  it "is invalid given duplicate name" do
    described_class.create!(name: "タグ")
    expect(described_class.new(name: "タグ")).not_to be_valid
  end
end
