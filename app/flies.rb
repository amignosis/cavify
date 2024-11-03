# frozen_string_literal: true

# This is the Flies module. Flies appear in front of the dragonfly. The dragonfly can spit
# fireballs at them to score points.
module Flies
  class << self
    def initialize(args)
      args.state.flies ||= [spawn(args), spawn(args), spawn(args)]
      args.state.flies.each { |fly| animate(fly) }
    end

    def spawn(args)
      size = 32
      {
        x: rand(args.grid.w * 0.4) + args.grid.w * 0.6,
        y: rand(args.grid.h - size * 2) + size,
        w: size,
        h: size,
        path: 'sprites/fly/fly-0',
        angle: rand * Math::PI * 2, # This will be the initial angle for the fly
        radius: rand * 10 + 10,     # This is the radius of the circle the fly will move in
        speed: rand * 0.05 + 0.05,  # This is the speed at which the fly will move
        initial_x: nil,             # This will store the initial x position of the fly
        initial_y: nil              # This will store the initial y position of the fly
      }
    end

    def animate(fly)
      index = 0.frame_index(count: 2, hold_for: 3, repeat: true)
      fly.path = "sprites/fly/fly-#{index}.png"
    end

    def animate_all(args)
      args.state.flies.each do |fly|
        cache_initial_position(fly)
        rotate(fly)
        update_position(fly)
      end
    end

    def cache_initial_position(fly)
      fly[:initial_x] ||= fly[:x]
      fly[:initial_y] ||= fly[:y]
    end

    def rotate(fly)
      fly[:angle] += fly[:speed]
    end

    def update_position(fly)
      # Update the position of the fly based on its angle, speed, and the radius of its circular path
      fly[:x] = fly[:initial_x] + Math.cos(fly[:angle]) * fly[:radius]
      fly[:y] = fly[:initial_y] + Math.sin(fly[:angle]) * fly[:radius]
    end
  end
end
