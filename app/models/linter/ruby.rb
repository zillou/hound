module Linter
  class Ruby < Base
    FILE_REGEXP = /.+\.rb\z/

    def file_review(commit_file)
      perform_file_review(commit_file)
    end

    def file_included?(commit_file)
      !merged_config.file_to_exclude?(commit_file.filename)
    end

    private

    def perform_file_review(commit_file)
      FileReview.create!(filename: commit_file.filename) do |file_review|
        team.inspect_file(parsed_source(commit_file)).each do |violation|
          line = commit_file.line_at(violation.line)
          file_review.build_violation(line, violation.message)
        end

        file_review.build = build
        file_review.complete
      end
    end

    def team
      RuboCop::Cop::Team.new(RuboCop::Cop::Cop.all, merged_config)
    end

    def parsed_source(commit_file)
      absolute_filepath = File.expand_path(commit_file.filename)
      RuboCop::ProcessedSource.new(commit_file.content, absolute_filepath)
    end

    def merged_config
      @merged_config ||= RuboCop::ConfigLoader.merge_with_default(
        custom_config.to_hash,
        ""
      )
    end

    def custom_config
      RuboCop::Config.new(config.content, "").tap do |custom_config|
        custom_config.add_missing_namespaces
        custom_config.make_excludes_absolute
      end
    rescue
      RuboCop::Config.new
    end
  end
end
