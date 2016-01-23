class ConfigBuilder
  def self.for(**args)
    new(**args).config
  end

  def initialize(hound_config:, repo:, linter_name:)
    @hound_config = hound_config
    @repo = repo
    @linter_name = linter_name
  end

  def config
    config_class.new(
      repo: repo,
      hound_config: hound_config,
      linter_name: linter_name,
    )
  end

  private

  attr_reader :hound_config, :repo, :linter_name

  def config_class
    "Config::#{linter_name.classify}".constantize
  rescue
    Config::Unsupported
  end
end
