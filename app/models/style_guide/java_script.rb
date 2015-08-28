module StyleGuide
  class JavaScript < Base
    DEFAULT_CONFIG_FILENAME = "javascript.json"

    def file_review(commit_file)
      FileReview.new(filename: commit_file.filename) do |file_review|
        Jshintrb.lint(commit_file.content, config).compact.each do |violation|
          line = commit_file.line_at(violation["line"])
          file_review.build_violation(line, violation["reason"])
        end
        file_review.complete
      end
    end

    def file_included?(commit_file)
      !excluded_files.any? do |pattern|
        File.fnmatch?(pattern, commit_file.filename)
      end
    end

    private

    def config
      repo_config.for(name)
    end

    def excluded_files
      repo_config.ignored_javascript_files
    end

    def name
      "javascript"
    end
  end
end
