class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.references :tag, index: true
      t.references :taggable, polymorphic: true

      t.datetime :created_at
    end
    add_index :taggings, [:taggable_type, :taggable_id]
  end
end
