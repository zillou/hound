class RubyViolationAnalytics
  def initialize(repos)
    @repos = repos
  end

  def violation_counts
    messages
      .group_by { |message| message }
      .map do |message, message_group|
        {
          message: message,
          count: message_group.count
        }
      end
      .sort_by { |violation_count| violation_count[:count] }
      .reverse
      .take(20)
  end

  private

  def messages
    @messages ||= @repos.flat_map do |repo|
      build_ids = repo.build_ids
      violations = Violation.where(build_id: build_ids)
        .where("filename ILIKE ?", "%.rb")
      violations.flat_map { |violation| violation.messages }
    end
  end
end
