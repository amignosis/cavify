# frozen_string_literal: true

require 'app/flies'
require 'app/score'

# This is the Fireballs module. Fireballs are spit by the dragonfly to hit the flies.
module Fireballs
  class << self
    def initialize(args)
      args.state.fireballs ||= []
      args.state.fireball_size ||= 32
    end

    def spit_sound(args)
      args.audio[:fireball] = { input: 'sounds/fireball.wav', looping: false }
    end

    def spit(args)
      spit_sound(args)
      args.state.fireballs << spawn(args)
    end

    def animate(fireball)
      index = 0.frame_index(count: 3, hold_for: 3, repeat: true)
      fireball.path = "sprites/fireball/fireball-#{index}.png"
    end

    def move(args, fireball)
      fireball.x += args.state.player.speed + 2
      animate(fireball)
    end

    # We pass the fireball that has hit the fly as arguments,
    # to mark them both as dead, play a sound, and spawn a new fly.
    def fly_has_been_hit(args, fireball, fly)
      args.audio[:fly_hit] = { input: 'sounds/fly-hit.wav', looping: false }
      fly.dead = true
      fireball.dead = true
      Score.increase(args)
      args.state.flies << Flies.spawn(args)
    end

    def spawn(args)
      {
        x: args.state.player.x + args.state.player.w - 12,
        y: args.state.player.y + 10,
        w: args.state.fireball_size,
        h: args.state.fireball_size
      }
    end

    def detect_collision(args)
      args.state.fireballs.each do |fireball|
        move(args, fireball)
        next if fireball_is_out_of_bounds!(args, fireball)

        args.state.flies.each do |fly|
          next unless args.geometry.intersect_rect?(fly, fireball, 5)

          fly_has_been_hit(args, fireball, fly)
        end
      end
    end

    def fireball_is_out_of_bounds!(args, fireball)
      return false unless fireball.x > args.grid.w

      # Kill the fireball if it went beyond the edge of the screen
      fireball.dead = true
    end
  end
end
