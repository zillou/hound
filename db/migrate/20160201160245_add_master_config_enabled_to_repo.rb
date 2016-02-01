class AddMasterConfigEnabledToRepo < ActiveRecord::Migration
  def change
    add_column :repos, :master_config_enabled, :boolean, default: false, null: false
  end
end
