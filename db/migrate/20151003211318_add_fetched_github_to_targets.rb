class AddFetchedGithubToTargets < ActiveRecord::Migration
  def change
    add_column :oss_targets, :fetched_github, :boolean, null: false, default: false
  end
end
