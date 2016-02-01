require "spec_helper"
require "app/models/config/base"
require "app/models/config/eslint"
require "app/models/config/parser"

describe Config::Eslint do
  describe "#content" do
    it "parses the configuration using YAML" do
      raw_config = <<-EOS.strip_heredoc
        rules:
          quotes: [2, "double"]
      EOS
      commit = stubbed_commit("config/.eslintrc" => raw_config)
      config = build_config(commit)

      expect(config.content).to eq Config::Parser.yaml(raw_config)
    end
  end

  def build_config(commit)
    hound_config = double(
      "HoundConfig",
      commit: commit,
      content: {
        "eslint" => { "enabled": true, "config_file" => "config/.eslintrc" },
      },
    )
    Config::Eslint.new(
      hound_config: hound_config,
      repo: double("Repo"),
      linter_name: "eslint",
    )
  end
end
