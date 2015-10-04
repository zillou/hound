class AddLanguageToTargets < ActiveRecord::Migration
  def change
    add_column :oss_targets, :language, :string
  end
end
