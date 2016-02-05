require "rails_helper"

describe Owner do
  it { should have_many(:repos) }

  describe ".upsert" do
    context "when owner does not exist" do
      it "creates owner" do
        github_id = 1234
        name = "thoughtbot"
        organization = true

        new_owner = Owner.upsert(
          github_id: github_id,
          name: name,
          organization: organization
        )

        expect(new_owner).to be_persisted
      end
    end

    context "when owner exists" do
      it "updates owner" do
        owner = create(:owner)
        new_name = "ralphbot"

        updated_owner = Owner.upsert(
          github_id: owner.github_id,
          name: new_name,
          organization: true
        )

        expect(updated_owner.name).to eq new_name
        expect(updated_owner.organization).to eq true
      end
    end
  end

  describe "#has_master_config?" do
    context "when the repo has enabled the master config" do
      it "returns true" do
        owner = build(
          :owner,
          master_config_enabled: true,
          master_config: "thoughtbot/hound",
        )

        expect(owner.has_master_config?).to eq true
      end

      context "when the repo has not specified a master config" do
        it "returns false" do
          owner = build(
            :owner,
            master_config_enabled: true,
            master_config: "",
          )

          expect(owner.has_master_config?).to eq false
        end
      end
    end

    context "when the repo has disabled the master config" do
      it "returns false" do
        owner = build(
          :owner,
          master_config_enabled: false,
          master_config: "thoughtbot/hound",
        )

        expect(owner.has_master_config?).to eq false
      end
    end
  end
end
