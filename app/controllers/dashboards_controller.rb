class DashboardsController < ApplicationController
  def show
    @violation_counts = RubyViolationAnalytics.new(current_user.repos.active)
      .violation_counts

    respond_to do |format|
      format.html
      format.json do
        render json: @violation_counts
      end
    end
  end
end
