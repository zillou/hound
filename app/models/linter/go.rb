module Linter
  class Go < Base
    FILE_REGEXP = /.+\.go\z/

    def file_included?(commit_file)
      !vendored?(commit_file.filename)
    end

    private

    def vendored?(filename)
      path_components = Pathname(filename).each_filename

      path_components.include?("vendor") ||
        path_components.take(2) == ["Godeps", "_workspace"]
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
