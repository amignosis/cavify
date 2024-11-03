# frozen_string_literal: true

# This is the player module. The player is the dragonfly!
module Player
  class << self
    def initialize(args)
      args.state.player ||= {
        x: 120,
        y: 280,
        w: 64,
        h: 64,
        speed: 12
      }
    end

    def fired?(args)
      args.inputs.keyboard.key_down.z ||
        args.inputs.keyboard.key_down.j ||
        args.inputs.controller_one.key_down.a ||
        args.inputs.keyboard.key_down.space
    end

    def animate(args, speed)
      index = 0.frame_index(count: 12, hold_for: speed, repeat: true)
      args.state.player.path = "sprites/dragonfly/dragonfly-#{index}.png"
    end

    def update_animation(args)
      if args.state.player.moved
        animate(args, 1)
        args.state.player.moved = false
      else
        animate(args, 3)
      end
    end

    def move(args)
      moved = moved_left?(args)
      moved_right?(args) unless moved
      moved = moved_up?(args)
      moved ||= moved_down?(args)
      check_boundaries(args)
      return unless moved

      args.state.player.moved = moved
    end

    def check_boundaries(args)
      touched_right_boundary(args)
      touched_top_boundary(args)
      args.state.player.x = 0 if args.state.player.x.negative?
      args.state.player.y = 0 if args.state.player.y.negative?
    end

    def rightmost_position(args)
      args.grid.w - args.state.player.w
    end

    def topmost_position(args)
      args.grid.h - args.state.player.h
    end

    def touched_right_boundary(args)
      args.state.player.x = rightmost_position(args) if args.state.player.x + args.state.player.w > args.grid.w
    end

    def touched_top_boundary(args)
      args.state.player.y = topmost_position(args) if args.state.player.y + args.state.player.h > args.grid.h
    end

    def moved_left?(args)
      return false unless args.inputs.left

      args.state.player.x -= args.state.player.speed
      true
    end

    def moved_right?(args)
      return false unless args.inputs.right

      args.state.player.x += args.state.player.speed
      true
    end

    def moved_up?(args)
      return false unless args.inputs.up

      args.state.player.y += args.state.player.speed
      true
    end

    def moved_down?(args)
      return false unless args.inputs.down

      args.state.player.y -= args.state.player.speed
      true
    end
  end
end
