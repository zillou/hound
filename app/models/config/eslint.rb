module Config
  class Eslint < Base
    def serialize(data = content)
      Serializer.json(data)
    end

    private

    def parse(file_content)
      content_without_comments = JsonComments.new(file_content).remove
      Parser.yaml(content_without_comments)
    end

    def default_content
      {}
    end
  end
end
