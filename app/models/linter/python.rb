module Linter
  class Python < Base
    FILE_REGEXP = /.+\.py\z/

    private

    def enqueue_job(attributes)
      Resque.push(
        "python_review",
        {
          class: "review.PythonReviewJob",
          args: [attributes],
        }
      )
    end

    def build_review_job_attributes(commit_file)
      {
        commit_sha: build.commit_sha,
        config: config.content,
        content: commit_file.content,
        filename: commit_file.filename,
        patch: commit_file.patch,
        pull_request_number: build.pull_request_number,
      }
    end
  end
end
