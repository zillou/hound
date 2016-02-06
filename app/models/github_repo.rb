class GithubRepo
  USER_WITH_DEFAULT_TOKEN = User.new(token: Hound::GITHUB_TOKEN)

  def initialize(repo)
    @repo = repo
  end

  def token
    token_user.token
  end

  def remove_user
    repo.remove_membership(token_user)
  end

  def token_user
    @token_user ||= users_with_token.sample || USER_WITH_DEFAULT_TOKEN
  end

  private

  attr_reader :repo

  def users_with_token
    repo.users_with_token
  end
end
