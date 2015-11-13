require "rails_helper"

describe Linter::Ruby do
  describe ".can_lint?" do
    context "given a .rb file" do
      it "returns true" do
        result = Linter::Ruby.can_lint?("foo.rb")

        expect(result).to eq true
      end
    end

    context "given a non-ruby file" do
      it "returns false" do
        result = Linter::Ruby.can_lint?("foo.js")

        expect(result).to eq false
      end
    end
  end

  describe "#file_review" do
    it "returns a saved and completed file review" do
      linter = build_linter

      result = linter.file_review(build_file("test"))

      expect(result).to be_persisted
      expect(result).to be_completed
    end

    context "with default configuration" do
      context "when double quotes are used" do
        it "finds violation during review" do
          violations = violations_in(<<-CODE)
            foo = "bar"
          CODE

          expect(violations).to(
            include "Prefer single-quoted strings when you don't need string interpolation or special symbols."
          )
        end
      end
    end

    context "with custom configuration" do
      context "when double quotes are preferred" do
        context "with namespaced cop" do
          it "does not find a violation during review" do
            config = stub_ruby_config(
              "Style/StringLiterals" => {
                "EnforcedStyle" => "double_quotes"
              }
            )

            violations = violations_in(<<-CODE, config: config)
              foo = "bar"
            CODE

            expect(violations).not_to(
              include "Prefer single-quoted strings when you don't need string interpolation or special symbols."
            )
          end
        end

        context "without namespaced cop" do
          it "does not find a violation during review" do
            config = stub_ruby_config(
              "StringLiterals" => {
                "EnforcedStyle" => "double_quotes"
              }
            )

            violations = violations_in(<<-CODE, config: config)
              foo = "bar"
            CODE

            expect(violations).not_to(
              include "Prefer single-quoted strings when you don't need string interpolation or special symbols."
            )
          end
        end
      end
    end

    describe "#file_included?" do
      context "with excluded file" do
        it "returns false" do
          config = stub_ruby_config(
            "AllCops" => { "Exclude" => ["ignore.rb"] },
          )
          file = double("CommitFile", filename: "ignore.rb")
          linter = build_linter(config: config)

          expect(linter.file_included?(file)).to eq false
        end
      end

      context "with included file" do
        it "returns true" do
          config = stub_ruby_config("AllCops" => { "Exclude" => [] })
          file = double("CommitFile", filename: "app.rb")
          linter = build_linter(config: config)

          expect(linter.file_included?(file)).to eq true
        end
      end
    end

    private

    def violations_in(
      content,
      config: stub_ruby_config,
      repository_owner_name: "joe"
    )
      hound_config = build_hound_config
      linter = build_linter(
        hound_config: hound_config,
        config: config,
        repository_owner_name: repository_owner_name,
      )

      linter.
        file_review(build_file(content)).
        violations.
        flat_map(&:messages)
    end

    def build_linter(
      hound_config: build_hound_config,
      config: stub_ruby_config,
      repository_owner_name: "not_thoughtbot"
    )
      config
      Linter::Ruby.new(
        hound_config: hound_config,
        build: build(:build),
        repository_owner_name: repository_owner_name,
      )
    end

    def stub_ruby_config(config = {})
      stubbed_ruby_config = double("RubyConfig", content: config)
      allow(Config::Ruby).to receive(:new).and_return(stubbed_ruby_config)

      stubbed_ruby_config
    end

    def build_hound_config
      double("HoundConfig", enabled_for?: true, content: "")
    end

    def build_file(content)
      build_commit_file(filename: "app/models/user.rb", content: content)
    end
  end
end
