FPS = 60
HIGH_SCORE_FILE = "high-score.txt"

def player_fired?(args)
  args.inputs.keyboard.key_down.z ||
    args.inputs.keyboard.key_down.j ||
    args.inputs.controller_one.key_down.a ||
    args.inputs.keyboard.key_down.space
end

def title_scene(args)
  args.outputs.background_color = [0, 0, 0]
  if player_fired?(args)
    args.audio[:game_over] = { input: "sounds/game-over.wav", looping: false }
    args.state.scene = "level1"
    return
  end

  labels = []
  labels << {
    x: 480,
    y: args.grid.h - 220,
    size_px: 28,
    text: "Highscore to beat is #{args.state.high_score}",
    r: 10,
    g: 10,
    b: 100,
  }
  args.outputs.labels << labels
end

def toggle_fullscreen(args)
  args.state.fullscreen = !args.state.fullscreen
  args.gtk.set_window_fullscreen(args.state.fullscreen)
end

def tick args
  args.state.fullscreen ||= false
  toggle_fullscreen(args) if args.inputs.keyboard.key_down.f
  args.state.high_score ||= args.gtk.read_file(HIGH_SCORE_FILE).to_i
  args.state.scene ||= "title"
  if !args.inputs.keyboard.has_focus && args.state.tick_count != 0
    args.outputs.background_color = [0, 0, 0]
    args.outputs.labels << { x: 640, y: 360, text: "Game Paused (click to resume).", alignment_enum: 1, r: 255, g: 255, b: 255 }
  else
    send("#{args.state.scene}_scene", args)
  end
end

$gtk.reset
