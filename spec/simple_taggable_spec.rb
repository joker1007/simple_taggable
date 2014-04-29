require 'spec_helper'

describe SimpleTaggable do
  describe "including class" do
    subject { User.new }

    it { should have_many(:taggings) }
    it { should have_many(:tags).through(:taggings) }


    let(:joker1007) { User.create(name: "joker1007") }
    let(:tag1) { SimpleTaggable::Models::Tag.create(name: "Tag1") }
    let(:tag2) { SimpleTaggable::Models::Tag.create(name: "Tag2") }

    describe "Named Scope" do
      describe ".tagged_with" do
        let(:joseph) { User.create(name: "joseph") }

        before do
          joker1007.tags << [tag1, tag2]
          joseph.tags << tag2
        end

        it "should return relation which has given tag string" do
          expect(User.tagged_with("Tag1")).to eq [joker1007]
          expect(User.tagged_with("Tag2")).to match_array [joker1007, joseph]
          expect(User.tagged_with("Tag2", "Tag1")).to match_array [joker1007, joseph]
          expect(User.tagged_with("Tag1", "Tag3")).to eq [joker1007]
        end

        context "Given match_all option" do
          it "should return relation which has given all tag string" do
            expect(User.tagged_with("Tag2", "Tag1", match_all: true)).to eq [joker1007]
            expect(User.tagged_with("Tag1", "Tag3", match_all: true)).to be_empty
          end
        end

        context "Given exclude option" do
          it "should return relation which has no given tag string" do
            expect(User.tagged_with("Tag1", exclude: true)).to eq [joseph]
            expect(User.tagged_with("Tag2", exclude: true)).to be_empty
            expect(User.tagged_with("Tag3", exclude: true)).to match_array [joker1007, joseph]
            expect(User.tagged_with("Tag1", "Tag3", exclude: true)).to eq [joseph]
            expect(User.tagged_with("Tag1", "Tag2", exclude: true)).to be_empty
            expect(User.tagged_with("Tag2", "Tag3", exclude: true)).to be_empty
            expect(User.tagged_with("Tag1", "Tag2", "Tag3", exclude: true)).to be_empty
          end
        end

        context "Given match_all and exclude" do
          it "should raise RuntimeError" do
            expect { User.tagged_with("Tag1", exclude: true, match_all: true) }
              .to raise_error(RuntimeError)
          end
        end
      end
    end

    describe "#tag_list" do
      before do
        joker1007.tags << [tag1, tag2]
      end

      it "should return TagList that is initialized by self.tags" do
        reloaded = User.find(joker1007.id)
        expect(reloaded.tag_list).to match_array SimpleTaggable::TagList.new("Tag1", "Tag2")
      end

      describe "filters and converters" do
        class TagFilteredUser < User
          add_tag_filter ->(tag_list, tag) { tag != "FILTERED" }
          add_tag_filter ->(tag_list, tag) { tag != "filtered" }
        end

        class TagConvertedUser < User
          add_tag_filter ->(tag_list, tag) { tag != "FILTERED" }
          add_tag_converter ->(tag_list, tag) { tag.upcase }
          add_tag_converter ->(tag_list, tag) { tag.gsub(/FOO/, "BAR") }
        end

        class InheritedUser < TagConvertedUser
          reset_tag_converters
          add_tag_filter ->(tag_list, tag) { tag != "FILTERED" }
          add_tag_converter ->(tag_list, tag) { tag.downcase }
        end

        it "use filter given add_tag_filter method, when initialize TagList" do
          tag_filtered_user = TagFilteredUser.new(name: "jotaro")
          tag_filtered_user.tag_list.add("Tag1", "FILTERED", "filtered")
          expect(tag_filtered_user.tag_list).to match_array SimpleTaggable::TagList.new("Tag1")
        end

        it "use converter given add_tag_converter method, when initialize TagList" do
          inherited_user = InheritedUser.new(name: "jotaro")
          inherited_user.tag_list.add("Tag1", "FILTERED")
          expect(inherited_user.tag_list).to match_array SimpleTaggable::TagList.new("tag1", "filtered")
        end

        it "inherit parent filters and converters" do
        end
      end
    end

    describe "#tag_list=" do
      it" should set TagList" do
        expect(joker1007.tag_list).to be_empty
        joker1007.tag_list = SimpleTaggable::TagList.new("Tag1")
        expect(joker1007.tag_list).to match_array SimpleTaggable::TagList.new("Tag1")
      end

      it "can receive Array" do
        expect(joker1007.tag_list).to be_empty
        joker1007.tag_list = ["Tag1"]
        expect(joker1007.tag_list).to match_array SimpleTaggable::TagList.new("Tag1")
      end

      it "can receive String" do
        expect(joker1007.tag_list).to be_empty
        joker1007.tag_list = "Tag1"
        expect(joker1007.tag_list).to match_array SimpleTaggable::TagList.new("Tag1")
      end

      it "raise ArgumentError if given not TagList nor Array object" do
        expect { joker1007.tag_list = 1 }.to raise_error(TypeError)
      end
    end

    context "After save" do
      before do
        joker1007.tags << tag1
        joker1007.instance_variable_set("@tag_list", nil)
        joker1007.tag_list << "Tag2"
      end

      it "create new tags included by tag_list" do
        expect(joker1007.tag_list).to match_array SimpleTaggable::TagList.new("Tag1", "Tag2")

        expect { joker1007.save! }.to change { joker1007.reload; joker1007.tags.size }
          .from(1).to(2)
      end

      it "delete old tags included by tag_list" do
        joker1007.tag_list.clear
        expect(joker1007.tag_list).to be_empty

        expect { joker1007.save! }.to change { joker1007.reload; joker1007.tags.size }
          .from(1).to(0)
      end
    end
  end
end
