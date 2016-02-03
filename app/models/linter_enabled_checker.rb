class LinterEnabledChecker
  def self.for(*configs)
    new(*configs).enabled?
  end

  def initialize(*configs)
    @linter_names = configs.flat_map(&:linter_names)
    @hound_configs = configs.flat_map(&:hound_config)
  end

  def enabled?
    @linter_names.any? do |linter_name|
      @hound_configs.any? do |hound_config|
        hound_config.enabled_for?(linter_name)
      end
    end
  end
end
