class ViolationAnalytics
  def initialize(repos)
    @repos = repos
  end

  def violation_counts
    violation_counts = messages.group_by { |message| message[0..18] }
      .map { |message, matching_messages| [message, matching_messages.count] }
    violation_counts.sort_by { |a, b| b }.reverse.take(10)
  end

  private

  def messages
    @repos[0..3].flat_map do |repo|
      builds = repo.builds
      builds
        .flat_map { |build| build.violations }
        .flat_map { |violation| violation.messages }
    end
  end
end
