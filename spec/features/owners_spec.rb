require "rails_helper"

feature "Owners" do
  scenario "Navigate to the owner's page", :js do
    user = create(:user, token_scopes: "public_repo,user:email")
    repo = create(:repo, full_github_name: "thoughtbot/my-repo")
    create(:membership, repo: repo, user: user, admin: true)

    sign_in_as(user)
    find(".settings a").click

    expect(current_path).to eq owner_path(repo.owner)
  end

  scenario "Set the master config repo" do
    user = create(:user, token_scopes: "public_repo,user:email")
    owner = create(:owner)
    repo = create(:repo, full_github_name: "thoughtbot/my-repo", owner: owner)

    sign_in_as(user)
    visit owner_path(owner)

    expect(page).to have_field(I18n.t("helpers.label.owner.config_repo"), "")

    fill_in I18n.t("helpers.label.owner.config_repo"), with: repo.name
    click_on I18n.t("helpers.submit.owner.update")
    visit owner_path(owner)

    expect(page).to have_field(
      I18n.t("helpers.label.owner.config_repo"),
      repo.name,
    )
  end
end
