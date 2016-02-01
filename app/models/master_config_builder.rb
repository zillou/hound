module MasterConfigBuilder
  HEAD = "HEAD".freeze

  def self.for(repo:, hound_config:, linter_name:)
    hound_config =
      if repo.master_config_enabled?
        github = GithubApi.new(Hound::GITHUB_TOKEN)
        commit = Commit.new(repo.master_config, HEAD, github)
        HoundConfig.new(commit)
      else
        hound_config
      end

    ConfigBuilder.for(
      repo: repo,
      hound_config: hound_config,
      linter_name: linter_name,
    )
  end
end
