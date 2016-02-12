class OrphanedAndMembershipReposQuery
  def initialize(user)
    @user = user
  end

  def run
    repos = @user.subscribed_repos.includes(:subscription)
    repos |= @user.repos_by_activation_ability.includes(:subscription)
  end
end
