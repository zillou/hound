class DashboardsController < ApplicationController
  def show
    @violation_counts = violation_counts
  end

  private

  def violation_counts
    active_repos = current_user.repos.active
    violation_counts = []
    active_repos[0..12].each do |repo|
      builds = repo.builds
      violation_count = builds.inject(0) do |memo, build|
        build.violations.count + memo
      end
      violation_counts << [repo.full_github_name, violation_count]
    end
    violation_counts
  end

end
