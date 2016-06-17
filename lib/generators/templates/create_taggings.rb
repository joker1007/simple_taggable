class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.references :tag, index: true
      t.references :taggable, polymorphic: true

      t.datetime :created_at, null: false
    end
    add_index :taggings, [:taggable_type, :taggable_id, :tag_id], unique: true
  end
end
