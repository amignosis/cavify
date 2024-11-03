# frozen_string_literal: true

require 'app/score'

HIGH_SCORE_FILE = 'high-score.txt'

# This is the highscore module. It keeps track of the high score, and saves it to a file.
module Highscore
  class << self
    def initialize(args)
      args.state.high_score ||= args.gtk.read_file(HIGH_SCORE_FILE).to_i
    end

    def get(args)
      args.state.high_score
    end

    def new?(args)
      Score.get(args) > get(args)
    end

    def save(args)
      return unless !args.state.saved_high_score && args.state.score > args.state.high_score

      args.gtk.write_file(HIGH_SCORE_FILE, args.state.score.to_s)
      args.state.saved_high_score = true
    end
  end
end
