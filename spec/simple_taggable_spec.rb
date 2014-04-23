require 'spec_helper'

describe SimpleTaggable do
  describe "including class" do
    subject { User.new }

    it { should have_many(:taggings) }
    it { should have_many(:tags).through(:taggings) }

    describe "Named Scope" do
      describe ".tagged_with" do
        it "should return relation which has given tag"
      end
    end
  end
end
