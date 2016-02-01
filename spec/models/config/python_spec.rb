require "spec_helper"
require "app/models/config/base"
require "app/models/config/python"
require "app/models/config/parser"

describe Config::Python do
  describe "#content" do
    it "parses the configuration using YAML" do
      raw_config = <<-EOS.strip_heredoc
        [flake8]
        max-line-length = 160
      EOS
      commit = stubbed_commit("config/python.ini" => raw_config)
      config = build_config(commit)

      expect(config.content).to eq Config::Parser.yaml(raw_config)
    end

    context "when there is no config content for the given linter" do
      it "returns the empty string" do
        hound_config = double(
          "HoundConfig",
          commit: double("Commit"),
          content: {},
        )
        config = Config::Python.new(
          repo: double("Repo"),
          hound_config: hound_config,
          linter_name: "unconfigured_linter",
        )

        expect(config.content).to eq ""
      end
    end
  end

  def build_config(commit)
    hound_config = double(
      "HoundConfig",
      commit: commit,
      content: {
        "python" => { "enabled": true, "config_file" => "config/python.ini" },
      },
    )

    Config::Python.new(
      hound_config: hound_config,
      repo: double("Repo"),
      linter_name: "python",
    )
  end
end
