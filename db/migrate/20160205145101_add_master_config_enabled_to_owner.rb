class AddMasterConfigEnabledToOwner < ActiveRecord::Migration
  def change
    add_column :owners, :master_config_enabled, :boolean, default: false, null: false
  end
end
