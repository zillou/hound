class CreateStyleGuide < ActiveRecord::Migration
  def change
    create_table :style_guides do |t|
      t.json :config, null: false
      t.boolean :enabled, default: true, null: false
      t.integer :language, null: false
      t.integer :owner_id, null: false
    end

    add_index :style_guides, [:owner_id, :language], unique: true
    add_foreign_key :style_guides, :owners

    execute "ALTER TABLE style_guides ALTER COLUMN config SET DEFAULT '{}'"
  end
end
