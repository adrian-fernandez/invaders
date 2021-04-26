require_relative "base_invader"

module Invaders
  module Invaders
    class Invader1 < BaseInvader
      PATTERN = <<~HEREDOC
        --o-----o--
        ---o---o---
        --ooooooo--
        -oo-ooo-oo-
        ooooooooooo
        o-ooooooo-o
        o-o-----o-o
        ---oo-oo---
      HEREDOC
    end
  end
end
