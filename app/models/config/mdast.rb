module Config
  class Mdast < Base
    private

    def parse(file_content)
      Config::Parser.json(file_content)
    end
  end
end
