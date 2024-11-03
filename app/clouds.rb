# frozen_string_literal: true

require 'app/utilities'

# This is the Clouds module.
module Clouds
  class << self
    def initialize(args)
      args.state.clouds ||= [spawn(args), spawn(args), spawn(args), spawn(args), spawn(args)]
    end

    # We create three different cloud sizes that run at different speeds.
    # They start from the right edge of the screen and move to the left.
    # We also set a random y position within the top half of the screen.
    # We set a random alpha value to give the clouds a sense of depth.
    def spawn(args)
      cloud_sizes = [128, 64, 32]
      cloud_speeds = [3, 2, 1]
      size_index = rand(cloud_sizes.length)
      size = cloud_sizes[size_index]
      half_height = args.grid.h / 2
      max_y = args.grid.h - size
      speed = cloud_speeds[size_index]
      {                                                    # Cloud hash
        x: args.grid.w,                                    # Start from the right edge of the screen
        y: Utilities.rand_from_range(half_height, max_y),  # Random y position within the top half of the screen
        w: size,                                           # Width
        h: size,                                           # Height
        path: 'sprites/cloud.png',                         # Path to the cloud sprite
        speed: speed,                                      # Speed
        should_remove: false,                              # Remove if off screen
        a: Utilities.rand_from_range(100, 200)             # Random alpha value (transparency)
      } # Return cloud hash
    end

    def spawn_many(args, number_of_clouds)
      number_of_clouds.times do
        args.state.clouds << spawn(args)
      end
    end

    def move(args)
      number_of_clouds_off_screen = 0
      args.state.clouds.each do |cloud|
        cloud.x -= cloud.speed
        if cloud.x < 0 - cloud.w
          cloud.should_remove = true
          number_of_clouds_off_screen += 1
        end
      end
      number_of_clouds_off_screen
    end
  end
end
