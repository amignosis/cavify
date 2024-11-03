# frozen_string_literal: true

# This is the score module.
module Score
  class << self
    def initialize(args)
      args.state.score ||= 0
    end

    def get(args)
      args.state.score
    end

    def increase(args)
      args.state.score += 1
    end

    def update(args)
      args.outputs.labels << {
        x: 40,
        y: args.grid.h - 40,
        text: "Score: #{get(args)}",
        size_enum: 4
      }
    end
  end
end
