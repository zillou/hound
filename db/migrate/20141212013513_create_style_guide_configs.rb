class CreateStyleGuideConfigs < ActiveRecord::Migration
  def change
    enable_extension "hstore"

    create_table :style_guide_configs do |t|
      t.string :name, null: false
      t.boolean :enabled, null: false
      t.integer :owner_id, null: false
      t.hstore :rules
      t.timestamps null: false

      t.index [:owner_id, :name], unique: true
    end
  end
end
