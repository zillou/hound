require "rails_helper"

describe OrphanedAndMembershipReposQuery do
  describe "#run" do
    context "when user is not a member of a repo but has a subscription for it" do
      it "includes the orphaned repo" do
        subscribed_repo = create(:repo, private: true)
        user = create(:user)
        create(:subscription, user: user, repo: subscribed_repo)

        repos = OrphanedAndMembershipReposQuery.new(user).run

        expect(repos).to include(subscribed_repo)
      end
    end
  end
end
