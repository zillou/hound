require "benchmark"

task benchmark: :environment do
  repos = User.find_by(github_username: "joannecheng").repos.active

  Benchmark.bm do |x|
    x.report("messages") do
      violations = RubyViolationAnalytics.new(repos)
      violations.messages
    end

    x.report("violations_counts") do
      violations = RubyViolationAnalytics.new(repos)
      violations.violation_counts
    end
  end
end
