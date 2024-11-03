# frozen_string_literal: true

FPS = 60

# This is the timer module.
module Timer
  class << self
    def initialize(args, number_of_seconds)
      args.state.timer ||= FPS * number_of_seconds
    end

    def get(args)
      args.state.timer
    end

    def decrease(args)
      args.state.timer -= 1
    end

    def time_left(args)
      (get(args) / FPS).round
    end

    def enough_time_has_passed?(args)
      get(args) < -30
    end

    def update(args)
       args.outputs.labels << {
        x: args.grid.w - 40,
        y: args.grid.h - 40,
        text: "Time Left: #{time_left(args)}",
        size_enum: 2,
        alignment_enum: 2
      }
    end
  end
end
