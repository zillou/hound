require "spec_helper"

describe StyleConfig do
  it { should belong_to(:owner) }

  describe "language validation" do
    context "with an invalid language" do
      it "is invalid" do
        style_config = build(:style_config, language: "foobar")

        expect(style_config).not_to be_valid
      end
    end

    context "with a valid language" do
      it "is valid" do
        pending
      end
    end
  end
end
