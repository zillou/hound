require "spec_helper"

describe StyleGuideConfig do
  it { should belong_to(:owner) }
  it { should validate_presence_of(:enabled) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:owner) }
  it {
    create(:style_guide_config)

    should validate_uniqueness_of(:owner_id).scoped_to(:name)
  }
end
