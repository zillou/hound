require "rails_helper"

describe LinterConfigsController do
  context "requesting ruby" do
    it "returns the merged RuboCop config", aggregate_failures: true do
      user = create(:user)
      stub_sign_in(user)
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
      stub_repo_request("thoughtbot/hound", user.token)
      stub_contents_request(
        sha: "master",
        repo_name: "thoughtbot/hound",
        file: ".hound.yml",
        body: { content: Base64.encode64(hound_yaml) }.to_json,
        token: user.token,
      )
      stub_contents_request(
        sha: "master",
        repo_name: "thoughtbot/hound",
        file: "ruby.yml",
        body: { content: Base64.encode64(YAML.dump(our_config)) }.to_json,
        token: user.token,
      )

      get :show, owner: "thoughtbot", repo: "hound", linter: "ruby"

      config = YAML.load(response.body)
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

  context "for an unsupported endpoint" do
    it "returns a 404" do
      user = create(:user)
      stub_sign_in(user)
      user.reload

      get :show, owner: "thoughtbot", repo: "hound", linter: "fortran"

      expect(response.status).to eq 404
    end
  end

  context "when user is not signed in" do
    it "redirects to root" do
      get :show, owner: "thoughtbot", repo: "hound", linter: "ruby"

      expect(response).to redirect_to(root_url)
    end
  end
end
