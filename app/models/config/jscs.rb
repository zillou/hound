module Config
  class Jscs < Base
    DEFAULT_CONTENT = {}

    def content
      super || DEFAULT_CONTENT
    end

    private

    def parse(file_content)
      Config::Parser.yaml(file_content)
    end
  end
end
