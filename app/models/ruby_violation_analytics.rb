class RubyViolationAnalytics
  def initialize(repos)
    @repos = repos
  end

  def violation_counts
    violation_counts = messages
      .group_by { |message| message }
      .map do |message, matching_messages|
        [message, matching_messages.count]
      end

    violation_counts.sort_by { |a, b| b }.reverse.take(20)
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

  def all_rules
    RuboCop::Cop::Cop.all.map do |cop|
      begin
        cop::MSG
      rescue NameError
      end
    end.compact.uniq
  end
end
