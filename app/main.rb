# frozen_string_literal: true

require 'app/utilities'
require 'app/player'
require 'app/fireballs'
require 'app/highscore'
require 'app/flies'
require 'app/clouds'
require 'app/score'
require 'app/timer'

def start_music(args)
  return unless args.state.tick_count == 1

  args.audio[:music] = { input: 'sounds/music.ogg', looping: true, gain: 1.0 }
end

def draw_background(args)
  args.outputs.solids << {
    x: 0,
    y: 0,
    w: args.grid.w,
    h: args.grid.h,
    r: 92,
    g: 120,
    b: 230
  }
end

def update(args)
  args.state.clouds.reject!(&:should_remove)
  args.state.flies.reject!(&:dead)
  args.state.fireballs.reject!(&:dead)
  Player.update_animation(args)
  args.outputs.sprites << [args.state.clouds, args.state.player, args.state.fireballs, args.state.flies]
end

def title_scene(args)
  args.outputs.sprites << {
    x: 0,
    y: 0,
    w: args.grid.w,
    h: args.grid.h,
    path: 'sprites/title-scene.png'
  }
  if Player.fired?(args)
    args.audio[:game_over] = { input: 'sounds/game-over.wav', looping: false }
    args.state.scene = 'level1'
    return
  end
  args.outputs.labels << {
    x: 480,
    y: args.grid.h - 220,
    size_px: 28,
    text: "High score to beat is #{Highscore.get(args)}",
    r: 10,
    g: 10,
    b: 100
  }
end

def level1_scene(args)
  Player.initialize(args)
  Fireballs.initialize(args)
  Clouds.initialize(args)
  Flies.initialize(args)
  Score.initialize(args)
  Timer.initialize(args, 30)
  draw_background(args)
  Timer.decrease(args)
  if Timer.get(args).zero?
    args.audio[:music].paused = true
    args.audio[:game_over] = { input: 'sounds/game-over.wav', looping: false }
    args.state.scene = 'game_over'
    return
  end
  Player.move(args)
  Fireballs.spit(args) if Player.fired?(args)
  number_of_clouds_off_screen = Clouds.move(args)
  Flies.animate_all(args)
  Clouds.spawn_many(args, number_of_clouds_off_screen) if number_of_clouds_off_screen.positive?
  Fireballs.detect_collision(args)
  update(args)
  Score.update(args)
  Timer.update(args)
end

def game_over_scene(args)
  Timer.decrease(args)
  Highscore.save(args)

  labels = []
  labels << {
    x: 40,
    y: args.grid.h - 40,
    text: 'Game Over!',
    size_enum: 10
  }
  labels << {
    x: 40,
    y: args.grid.h - 90,
    text: "Score: #{Score.get(args)}",
    size_enum: 4
  }
  labels << {
    x: 40,
    y: args.grid.h - 132,
    text: 'Fire to restart',
    size_enum: 2
  }
  labels << if Highscore.new?(args)
              {
                x: 260,
                y: args.grid.h - 90,
                text: 'New High Score!',
                size_enum: 3
              }
            else
              {
                x: 260,
                y: args.grid.h - 90,
                text: "Score to beat: #{Highscore.get(args)}",
                size_enum: 3
              }
            end
  args.outputs.labels << labels
  return unless Timer.enough_time_has_passed?(args) && Player.fired?(args)

  $gtk.reset
end

def tick(args)
  Utilities.toggle_fullscreen_init(args)
  Utilities.toggle_fullscreen(args) if args.inputs.keyboard.key_down.f
  Highscore.initialize(args)
  start_music(args)
  args.state.scene ||= 'title'
  if !args.inputs.keyboard.has_focus && args.state.tick_count != 0
    args.outputs.background_color = [0, 0, 0]
    args.outputs.labels << {
      x: 640,
      y: 360,
      text: 'Game Paused (click to resume).',
      alignment_enum:
      1,
      r: 255,
      g: 255,
      b: 255
    }
    args.audio[:music].gain = 0.0 unless args.state.tick_count < 1
  else
    args.audio[:music].gain = 1.0 unless args.state.tick_count < 1
    send("#{args.state.scene}_scene", args)
  end
end

$gtk.reset
