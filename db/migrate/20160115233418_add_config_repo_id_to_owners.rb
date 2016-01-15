class AddConfigRepoIdToOwners < ActiveRecord::Migration
  def change
    add_column :owners, :config_repo, :string, index: true
  end
end
