class LinterConfigsController < ApplicationController
  layout false

  def show
    github = GithubApi.new(current_user.token)
    # TODO: don't hardcode master
    head_commit = Commit.new(full_github_name, "master", github)
    hound_config = HoundConfig.new(head_commit)

    config = case params[:linter]
    when "ruby"
      ruby_config = Config::Ruby.new(hound_config, "ruby")
      RubyConfigBuilder.new(ruby_config.content, params[:owner]).config
    else
      { error: "not implemented yet" }
    end

    render body: config.to_yaml, content_type: "text/yaml"
  end

  protected

  # def head_commit(org_name, repo_name)
  # end

  def repo
    Repo.find_by(full_github_name: full_github_name)
  end

  def full_github_name
    "#{params[:owner]}/#{params[:repo]}"
  end
end
