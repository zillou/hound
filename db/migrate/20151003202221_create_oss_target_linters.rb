class CreateOssTargetLinters < ActiveRecord::Migration
  def change
    create_table :oss_target_linters do |t|
      t.timestamps null: false
      t.string :name, null: false
      t.integer :oss_target_id, null: false
    end

    add_index :oss_target_linters, :oss_target_id
  end
end
