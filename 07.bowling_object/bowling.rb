#!/usr/bin/env ruby
# frozen_string_literal: true

class Shot
  attr_reader :mark

  def initialize(mark)
    @mark = mark
  end

  def to_score
    mark == 'X' ? 10 : mark.to_i
  end
end

class Frame
  attr_reader :marks, :frame

  def initialize(*marks)
    @frame = marks.map { |m| Shot.new(m).to_score }
  end

  def strike?
    frame[0] == 10
  end

  def spare?
    frame.sum == 10
  end

  def score
    frame.sum
  end
end

class Game
  attr_reader :marks, :frames

  def initialize(marks)
    @marks = marks.chars
    @frames = to_frames
  end

  def to_frames
    frames = []
    rolls = []
    marks.each.with_index do |m, i|
      rolls << m
      if frames.size < 9
        if rolls.size >= 2 || m == 'X'
          frames << Frame.new(*rolls)
          rolls.clear
        end
      elsif i == marks.size - 1
        frames << Frame.new(*rolls)
      end
    end
    frames
  end

  def calc_score
    frames.each.with_index.sum do |f, num|
      num == 9 ? f.score : f.score + add_bonus(f, left_shots(num))
    end
  end

  private

  def left_shots(num)
    next_frame = frames[num + 1] ? frames[num + 1].frame : []
    after_next_frame = frames[num + 2] ? frames[num + 2].frame : []
    next_frame + after_next_frame
  end

  def add_bonus(frame, left_shots)
    if frame.strike?
      left_shots.first(2).sum
    elsif frame.spare?
      left_shots.first
    else
      0
    end
  end
end

game = Game.new(ARGV[0])
puts game.calc_score
