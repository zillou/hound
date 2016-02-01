require "spec_helper"
require "app/models/config/base"
require "app/models/config/swift"
require "app/models/config/parser"

describe Config::Swift do
  describe "#content" do
    it "parses the configuration using YAML" do
      raw_config = <<-EOS.strip_heredoc
        disabled_rules:
          - colon
      EOS
      commit = stubbed_commit("config/swiftlint.yml" => raw_config)
      config = build_config(commit)

      expect(config.content).to eq Config::Parser.yaml(raw_config)
    end
  end

  def build_config(commit)
    hound_config = double(
      "HoundConfig",
      commit: commit,
      content: {
        "swift" => { "enabled": true, "config_file" => "config/swiftlint.yml" },
      },
    )

    Config::Swift.new(
      hound_config: hound_config,
      repo: double("Repo"),
      linter_name: "swift",
    )
  end
end
