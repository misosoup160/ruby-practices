#!/usr/bin/env ruby
# frozen_string_literal: true

class Shot
  def initialize(score)
    @score = score
  end

  def to_shots
    scores = @score.chars
    shots = []
    count = 0 # X以外のスコアを数える
    scores.each do |s|
      if s == 'X' && count.even?
        shots << 10
        shots << 0
        count = 0
      elsif s == 'X' && count.odd?
        shots << 10
        count = 0
      else
        shots << s.to_i
        count += 1
      end
    end
    shots
  end
end

class Frame
  def initialize(score)
    @shots = Shot.new(score).to_shots
  end

  def to_frames
    frames = []
    @shots.each_slice(2) do |s|
      frames << s
    end
    frames
  end
end

class Game
  def initialize(score)
    @frames = Frame.new(score).to_frames
  end

  def point
    point = 0
    @frames.each.with_index do |frame, i|
      if frame[0] == 10 && i < 9 # strike
        plus = @frames[i + 1][0] == 10 ? 10 + @frames[i + 2][0] : @frames[i + 1].sum
        point += 10 + plus
      elsif frame.sum == 10 && i < 9 # spare
        point += 10 + @frames[i + 1][0]
      else
        point += frame.sum
      end
    end
    point
  end
end

score = ARGV[0]
game = Game.new(score)
puts game.point
