module Config
  class Scss < Base
    private

    def parse(file_content)
      Parser.yaml(file_content)
    end
  end
end
