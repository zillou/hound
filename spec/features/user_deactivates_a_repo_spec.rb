require "rails_helper"

feature "user deactivates a repo", js: true do
  context "when the user has a subscription" do
    context "when the user does not have a membership" do
      scenario "successfully deactiavtes the repo" do
        token = "letmein"
        user = create(:user, token_scopes: "public_repo,user:email")
        repo = create(:repo, :active, private: true)
        create(:subscription, user: user, repo: repo)
        gateway_subscription = double(unsubscribe: true)
        payment_gateway_customer = double(
          retrieve_subscription: gateway_subscription,
        )
        allow(PaymentGatewayCustomer).to receive(:new).and_return(
          payment_gateway_customer
        )

        sign_in_as(user, token)
        find(".repos .toggle").click

        expect(page).not_to have_css(".active")
        expect(user.repos.active.count).to eq(0)
        expect(gateway_subscription).to have_received(:unsubscribe)

        visit current_path

        expect(page).not_to have_selector(".repo")
      end
    end
  end
end
