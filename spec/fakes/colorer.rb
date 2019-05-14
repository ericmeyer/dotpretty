module Fakes
  module Colorer

    def green(text)
      return "{green}#{text}{reset}"
    end

    def red(text)
      return "{red}#{text}{reset}"
    end

    def yellow(text)
      return "{yellow}#{text}{reset}"
    end

  end
end
