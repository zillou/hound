require "spec_helper"
require "app/models/config/base"
require "app/models/config/mdast"
require "app/models/config/parser"

describe Config::Mdast do
  describe "#content" do
    it "parses the configuration using JSON" do
      raw_config = <<-EOS.strip_heredoc
        {
          "heading-style": "setext"
        }
      EOS
      commit = stubbed_commit("config/.mdastrc" => raw_config)
      config = build_config(commit)

      expect(config.content).to eq Config::Parser.json(raw_config)
    end
  end

  def build_config(commit)
    hound_config = double(
      "HoundConfig",
      commit: commit,
      content: {
        "mdast" => { "enabled": true, "config_file" => "config/.mdastrc" },
      },
    )

    Config::Mdast.new(
      hound_config: hound_config,
      repo: double("Repo"),
      linter_name: "mdast",
    )
  end
end
