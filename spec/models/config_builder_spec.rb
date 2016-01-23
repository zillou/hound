require "rails_helper"

describe ConfigBuilder do
  describe ".for" do
    context "when there is matching config class for the given name" do
      it "returns the matching config" do
        config = ConfigBuilder.for(
          repo: double,
          hound_config: double,
          linter_name: "ruby",
        )

        expect(config).to be_a(Config::Ruby)
      end
    end

    context "when there is not matching config class for the given name" do
      it "returns the unsupported config" do
        config = ConfigBuilder.for(
          repo: double,
          hound_config: double,
          linter_name: "non-existent-config",
        )

        expect(config).to be_a(Config::Unsupported)
      end
    end
  end
end
