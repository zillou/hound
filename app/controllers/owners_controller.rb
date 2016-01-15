class OwnersController < ApplicationController
  def show
    owner = find_owner
    render locals: { owner: owner }
  end

  def update
    owner = find_owner
    owner.update(owner_params)

    redirect_to owner
  end

  private

  def find_owner
    Owner.find_by!(name: params[:id])
  end

  def owner_params
    params.require(:owner).permit(:config_repo)
  end
end
