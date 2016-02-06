require "spec_helper"
require "config/initializers/constants"
require "app/models/github_repo"

describe GithubRepo do
  describe "#token" do
    context "when no users with token are found" do
      it "returns hound's token" do
        repo = instance_double("Repo", users_with_token: [])
        github_repo = GithubRepo.new(repo)

        expect(github_repo.token).to eq Hound::GITHUB_TOKEN
      end
    end

    context "when user with a token is found" do
      it "returns user's token" do
        token = "foo_bar_token"
        user = instance_double("User", token: token)
        repo = instance_double("Repo", users_with_token: [user])
        github_repo = GithubRepo.new(repo)

        expect(github_repo.token).to eq token
      end
    end
  end

  describe "#remove_user" do
    it "removes user's membership to the repo" do
      user = instance_double("User")
      repo = instance_double(
        "Repo",
        users_with_token: [user],
        remove_membership: nil,
      )
      github_repo = GithubRepo.new(repo)

      github_repo.remove_user

      expect(repo).to have_received(:remove_membership).with(user)
    end
  end
end
