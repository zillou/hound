require "app/models/config/json_comments"

describe Config::JsonComments do
  describe "#remove" do
    context "with mixed comments" do
      it "returns raw JSON content without comments" do
        config = <<-TEXT.strip_heredoc
          /* start of file */
          {
            "foo": 1, // comments here
            "bar": 2,
            "baz": "// hello", // more comments
          }
          /* end of file */
        TEXT

        result = described_class.new(config).remove

        expect(result).to eq <<-TEXT.strip_heredoc
          {
            "foo": 1,
            "bar": 2,
            "baz": "// hello",
          }
        TEXT
      end
    end

    context "with single line comments" do
      it "returns raw JSON content without comments" do
        config = <<-TEXT.strip_heredoc
          {
            "foo": 1, // comments here
            "bar": 2,
          }
        TEXT

        result = described_class.new(config).remove

        expect(result).to eq <<-TEXT.strip_heredoc
          {
            "foo": 1,
            "bar": 2,
          }
        TEXT
      end
    end
  end
end
