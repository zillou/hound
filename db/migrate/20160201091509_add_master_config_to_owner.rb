class AddMasterConfigToOwner < ActiveRecord::Migration
  def change
    add_column :owners, :master_config, :text, default: "", null: false
  end
end
