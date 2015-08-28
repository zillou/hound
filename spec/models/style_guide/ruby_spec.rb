require "rails_helper"

describe StyleGuide::Ruby do
  describe "#file_review" do
    include ConfigurationHelper

    it "returns a completed file review" do
      repo_config = double("RepoConfig", enabled_for?: true, for: config)
      style_guide = StyleGuide::Ruby.new(repo_config, "bob")

      result = style_guide.file_review(build_file("test"))

      expect(result).to be_completed
    end

    context "with default configuration" do
      context "with double quotes" do
        it "finds violation" do
          violation = "Prefer single-quoted strings when you don't need string interpolation or special symbols."

          expect(violations_in(<<-CODE)).to include violation
            name = "Jim Tom"
          CODE
        end
      end
    end

    context "with custom configuration" do
      context "with double quotes preferred" do
        it "does not find violation" do
          config = {
            "Style/StringLiterals" => {
              "EnforcedStyle" => "double_quotes"
            }
          }
          violations = violations_in(<<-CODE, config: config)
            name = "Jim Tom"
          CODE

          expect(violations).not_to include(
            "Prefer single-quoted strings when you don't need string interpolation or special symbols."
          )
        end
      end

      it "supports display of RuboCop violation types" do
        config = {
          "AllCops" => {
            "DisplayCopNames" => "true"
          },
          "Style/StringLiterals" => {
            "EnforcedStyle" => "double_quotes"
          }
        }

        violations = violations_in(<<-CODE, config: config)
          name = 'Jim Tom'
        CODE

        expect(violations).to include(
          "Style/StringLiterals: Prefer double-quoted strings unless you need single quotes to avoid extra backslashes for escaping."
        )
      end

      context "with old-style syntax" do
        it "finds a violation" do
          config = {
            "StringLiterals" => {
              "EnforcedStyle" => "double_quotes"
            }
          }
          violations = violations_in(<<-CODE, config: config)
            name = "Jim Tom"
          CODE

          expect(violations).not_to include(
            "Prefer single-quoted strings when you don't need string interpolation or special symbols."
          )
        end
      end
    end

    describe "#file_included?" do
      context "with excluded file" do
        it "returns false" do
          config = {
            "AllCops" => {
              "Exclude" => ["ignore.rb"]
            }
          }
          repo_config = double("RepoConfig", for: config)
          file = double("CommitFile", filename: "ignore.rb")
          style_guide = StyleGuide::Ruby.new(repo_config, "ralph")

          expect(style_guide.file_included?(file)).to eq false
        end
      end

      context "with included file" do
        it "returns true" do
          config = {
            "AllCops" => {
              "Exclude" => []
            }
          }
          repo_config = double("RepoConfig", for: config)
          file = double("CommitFile", filename: "app.rb")
          style_guide = StyleGuide::Ruby.new(repo_config, "ralph")

          expect(style_guide.file_included?(file)).to eq true
        end
      end
    end

    private

    def violations_in(content, config: nil, repository_owner_name: "ralph")
      repo_config = double("RepoConfig", enabled_for?: true, for: config)
      style_guide = StyleGuide::Ruby.new(repo_config, repository_owner_name)
      style_guide.
        file_review(build_file(content)).
        violations.
        flat_map(&:messages)
    end

    def build_file(content)
      build_commit_file(filename: "app/models/user.rb", content: content)
    end
  end
end
