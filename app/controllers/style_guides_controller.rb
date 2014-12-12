class StyleGuidesController < ApplicationController
  def show
    if owner && user_belongs_to_org_owner
      @style_guide_config = StyleGuideConfig.find(params[:id])
    else
      head 404
    end
  end

  private

  def api
    GithubApi.new(session[:github_token])
  end

  def owner
    @owner ||= Owner.find_by(id: params[:owner_id])
  end

  def user_belongs_to_org_owner
    user_org_ids.include?(owner.github_id)
  end

  def user_org_ids
    api.orgs.map(&:id)
  end
end
