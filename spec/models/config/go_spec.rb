require "spec_helper"
require "app/models/config/base"
require "app/models/config/go"

describe Config::Go do
  describe "#content" do
    it "returns an empty string" do
      config = Config::Go.new(
        repo: double("Repo"),
        hound_config: double("HoundConfig"),
        linter_name: "go",
      )

      expect(config.content).to eq ""
    end
  end
end
