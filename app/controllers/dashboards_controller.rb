class DashboardsController < ApplicationController
  def show
    @violation_counts = RubyViolationAnalytics.new(current_user.repos.active)
      .violation_counts
  end
end
