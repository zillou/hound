require "rails_helper"

describe "/config/thoughtbot/hound/ruby" do
  context "with auth" do
    it "returns the merged config for the linter", aggregate_failures: true do
      user = create(:user)
      sign_in_as(user)
      our_config = {
        "Style/OptionHash" => {
          "Enabled" => true,
        }
      }
      hound_yaml = <<-HOUND.strip_heredoc
        ruby:
          enabled: true
          config_file: ruby.yml
      HOUND
      stub_contents_request(
        sha: "master",
        repo_name: "thoughtbot/hound",
        file: ".hound.yml",
        body: { content: Base64.encode64(hound_yaml) }.to_json,
        token: user.reload.token,
      )
      stub_contents_request(
        sha: "master",
        repo_name: "thoughtbot/hound",
        file: "ruby.yml",
        body: { content: Base64.encode64(YAML.dump(our_config)) }.to_json,
        token: user.reload.token,
      )

      visit "/config/thoughtbot/hound/ruby"

      config = YAML.load(page.body)
      expect(config["Style/StringLiterals"]).to match(hash_including(
        "EnforcedStyle" => "double_quotes",
        "Enabled" => true,
      ))
      expect(config["Style/OptionHash"]).to match(hash_including(
        "Enabled" => true,
      ))
      expect(config["Metrics/LineLength"]).to match(hash_including(
        "Max" => 80,
      ))
    end
  end
end
