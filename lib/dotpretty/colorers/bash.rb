module Dotpretty
  module Colorers
    module Bash

      RESET="\e[0m"
      START_GREEN="\033[32m"
      START_RED="\033[31m"

      def green(text)
        return "#{START_GREEN}#{text}#{RESET}"
      end

      def red(text)
        return "#{START_RED}#{text}#{RESET}"
      end

    end
  end
end
