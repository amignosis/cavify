# frozen_string_literal: true

# This module contains utility methods that can be used throughout the application.
module Utilities
  class << self
    # Pick a random number between from and to, inclusive
    def rand_from_range(from, to)
      rand((to - from) + 1) + from
    end

    def toggle_fullscreen_init(args)
      args.state.fullscreen ||= false
    end

    def toggle_fullscreen(args)
      args.state.fullscreen = !args.state.fullscreen
      args.gtk.set_window_fullscreen(args.state.fullscreen)
    end
  end
end
