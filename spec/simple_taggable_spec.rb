require 'spec_helper'

describe SimpleTaggable do
  describe "including class" do
    subject { User.new }

    it { should have_many(:taggings) }
    it { should have_many(:tags).through(:taggings) }
  end
end
