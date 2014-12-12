require "spec_helper"

describe "Updating a style guide" do
  context "when owner exists" do
    context "for organization owner" do
      it "updates style guide" do
        github_id = 6183 # from fixture
        github_name = "thoughtbot" # from fixture
        user = create(:user)
        owner = create(:owner, github_name: github_name, github_id: github_id)
        style_guide_config = create(:style_guide_config, owner: owner)
        rules = { "line_length" => { "value" => "100" } }
        stub_orgs_request('user-github-token')
        allow(User).to receive(:where).and_return([user])

        put(
          owner_style_guide_url(id: style_guide_config.id, owner_id: owner.id),
          { style_guide: { rules: rules } }
        )

        parsed_updated_rules = style_guide_config.reload.rules
        expect(response.status).to eq 200
        expect(parsed_updated_rules).to eq rules
      end
    end
  end
end

describe "Getting a style guide" do
  context "when owner does not exist" do
    it "returns 404" do
      nonexistent_owner_id = 0
      user = create(:user)
      style_guide_config = create(:style_guide_config)
      stub_orgs_request('user-github-token')
      allow(User).to receive(:where).and_return([user])

      get owner_style_guide_url(
        id: style_guide_config.id,
        owner_id: nonexistent_owner_id
      )

      expect(response.status).to eq 404
    end
  end

  context "when owner exists" do
    context "for organization owner" do
      context "when current user does not belong to organization" do
        it "returns 404" do
          user = create(:user)
          owner = create(:owner, github_name: "example", github_id: 1233)
          user = create(:user)
          stub_orgs_request('user-github-token')
          style_guide_config = create(:style_guide_config, owner: owner)
          allow(User).to receive(:where).and_return([user])

          get owner_style_guide_url(id: style_guide_config.id, owner_id: owner.id)

          expect(response.status).to eq 404
        end
      end

      context "when current user belongs to organization" do
        it "returns style guide" do
          github_id = 6183 # from fixture
          github_name = "thoughtbot" # from fixture
          user = create(:user)
          owner = create(:owner, github_name: github_name, github_id: github_id)
          style_guide_config = create(:style_guide_config, owner: owner)
          stub_orgs_request('user-github-token')
          allow(User).to receive(:where).and_return([user])

          get owner_style_guide_url(id: style_guide_config.id, owner_id: owner.id)

          expect(response.status).to eq 200
        end
      end
    end
  end
end
