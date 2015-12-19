require "rails_helper"

describe "/config/thoughtbot/hound/ruby" do
  context "without auth" do
    it "redirects to root" do
      get "/config/thoughtbot/hound/ruby"

      expect(response).to redirect_to(root_url)
    end
  end
end
