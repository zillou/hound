class DashboardsController < ApplicationController
  def show
    @violation_counts = ViolationAnalytics.new(current_user.repos.active)
      .violation_counts
  end
end
