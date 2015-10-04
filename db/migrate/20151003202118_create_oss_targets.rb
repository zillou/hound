class CreateOssTargets < ActiveRecord::Migration
  def change
    create_table :oss_targets do |t|
      t.timestamps null: false
      t.string :name, null: false
      t.integer :followers_count, null: false, default: 0
    end

    add_index :oss_targets, :followers_count
  end
end
