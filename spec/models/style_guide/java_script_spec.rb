require "rails_helper"

describe StyleGuide::JavaScript do
  include ConfigurationHelper

  describe "#file_review" do
    it "returns a completed file review" do
      repo_config = double("RepoConfig", enabled_for?: true, for: {})
      style_guide = StyleGuide::JavaScript.new(repo_config, "bob")
      commit_file = build_js_file

      result = style_guide.file_review(commit_file)

      expect(result).to be_completed
    end

    context "with default config" do
      context "without semicolon" do
        it "finds violation" do
          repo_config = double("RepoConfig", for: {})
          commit_file = build_js_file("var foo = 'bar'")

          violations = violations_in(
            commit_file: commit_file,
            repo_config: repo_config
          )

          violation = violations.first
          expect(violation.filename).to eq commit_file.filename
          expect(violation.line_number).to eq 1
          expect(violation.messages).to include "Missing semicolon."
        end
      end
    end

    context "with custom config" do
      context "when semicolons are optional" do
        it "does not find violation" do
          repo_config = double("RepoConfig", for: { "asi" => true })
          commit_file = build_js_file("parseFloat('1')")

          violations = violations_in(
            commit_file: commit_file,
            repo_config: repo_config
          )

          expect(violations).not_to include "Missing semicolon."
        end
      end
    end

    context "when jshintrb returns nil violation" do
      it "returns no violations" do
        repo_config = double("RepoConfig", for: {})
        commit_file = double("CommitFile").as_null_object
        allow(Jshintrb).to receive_messages(lint: [nil])

        violations = violations_in(
          commit_file: commit_file,
          repo_config: repo_config
        )

        expect(violations).to be_empty
      end
    end
  end

  describe "#file_included?" do
    context "file is in excluded file list" do
      it "returns false" do
        repo_config = double("RepoConfig", ignored_javascript_files: ["foo.js"])
        style_guide = StyleGuide::JavaScript.new(repo_config, "ralph")
        commit_file = double("CommitFile", filename: "foo.js")

        included = style_guide.file_included?(commit_file)

        expect(included).to be false
      end
    end

    context "file is not excluded" do
      it "returns true" do
        repo_config = double("RepoConfig", ignored_javascript_files: ["foo.js"])
        style_guide = StyleGuide::JavaScript.new(repo_config, "ralph")
        commit_file = double("CommitFile", filename: "bar.js")

        included = style_guide.file_included?(commit_file)

        expect(included).to be true
      end
    end

    it "matches a glob pattern" do
      repo_config = double(
        "RepoConfig",
        ignored_javascript_files: [
          "app/assets/javascripts/*.js",
          "vendor/*",
        ]
      )
      style_guide = StyleGuide::JavaScript.new(repo_config, "ralph")
      commit_file1 = double(
        "CommitFile",
        filename: "app/assets/javascripts/bar.js"
      )
      commit_file2 = double(
        "CommitFile",
        filename: "vendor/assets/javascripts/foo.js"
      )

      expect(style_guide.file_included?(commit_file1)).to be false
      expect(style_guide.file_included?(commit_file2)).to be false
    end
  end

  def build_js_file(content = "foo")
    build_commit_file(filename: "some-file.js", content: content)
  end

  def violations_in(
    commit_file:,
    repo_config:,
    repository_owner_name: "not_thoughtbot"
  )
    style_guide = StyleGuide::JavaScript.new(
      repo_config,
      repository_owner_name
    )
    style_guide.file_review(commit_file).violations
  end
end
