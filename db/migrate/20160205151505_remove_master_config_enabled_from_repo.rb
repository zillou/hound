class RemoveMasterConfigEnabledFromRepo < ActiveRecord::Migration
  def change
    remove_column :repos, :master_config_enabled, :boolean
  end
end
