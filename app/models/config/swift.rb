module Config
  class Swift < Base
    private

    def parse(file_content)
      Parser.yaml(file_content)
    end
  end
end
