require "spec_helper"

describe RubyViolationAnalytics do
  describe "#violation_counts" do
    it "works" do
      repo = create(:repo)
      build = create(:build, repo: repo)
      create(:violation, build: build, messages: ["Test message!"])
      create(
        :violation,
        build: build,
        messages: ["Line is too long. [81/80]", "Test message!"]
      )

      analytics = RubyViolationAnalytics.new([repo])

      expect(analytics.violation_counts).to eq(
        [
          ["Test message!", 2],
          ["Line is too long. [81/80]", 1]
        ]
      )
    end
  end
end
