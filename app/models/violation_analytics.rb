class ViolationAnalytics
  def initialize(repos)
    @repos = repos
  end

  def violation_counts
    violation_counts = []

    @repos.each do |repo|
      builds = repo.builds
      messages = builds
        .map { |build| build.violations }.flatten
        .map { |violation| violation.messages }
        .flatten
      violation_counts << messages.group_by do |message|
        message[0..18]
      end.map do |message, matching_messages|
        [message, matching_messages.count]
      end
    end
    violation_counts.flatten(1).sort_by { |a, b| b }.reverse.take(10)
  end
end
