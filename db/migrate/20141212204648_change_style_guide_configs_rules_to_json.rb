class ChangeStyleGuideConfigsRulesToJson < ActiveRecord::Migration
  def up
    change_column :style_guide_configs, :rules, 'json USING CAST(rules AS json)'
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
