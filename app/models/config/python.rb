module Config
  class Python < Base
    def content
      super || default_content
    end

    private

    def parse(file_content)
      Config::Parser.yaml(file_content)
    end

    def default_content
      ""
    end
  end
end
