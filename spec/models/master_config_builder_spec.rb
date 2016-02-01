require "rails_helper"

describe MasterConfigBuilder do
  describe ".for" do
    context "when the repo has a master config enabled" do
      it "returns the config connected to the master config" do
        stub_const("Hound::GITHUB_TOKEN", "sekkrit")
        repo = double(
          "Repo",
          master_config_enabled?: true,
          master_config: "thoughtbot/hound-legacy-config",
        )
        hound_config = double("HoundConfig")

        master_config = MasterConfigBuilder.for(
          repo: repo,
          hound_config: hound_config,
          linter_name: "ruby",
        )

        expect(master_config).to be_a Config::Ruby
        expect(master_config.hound_config).not_to eq hound_config
      end
    end

    context "when the repo does not have a master config enabled" do
      it "returns the config connected to the same repository" do
        stub_const("Hound::GITHUB_TOKEN", "sekkrit")
        repo = double(
          "Repo",
          master_config_enabled?: false,
          name: "thoughtbot/hound",
          master_config: "thoughtbot/hound-legacy-config",
        )
        hound_config = double("HoundConfig")

        master_config = MasterConfigBuilder.for(
          repo: repo,
          hound_config: hound_config,
          linter_name: "ruby",
        )

        expect(master_config).to be_a Config::Ruby
        expect(master_config.hound_config).to eq hound_config
      end
    end
  end
end
