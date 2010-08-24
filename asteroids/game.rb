#!/usr/bin/env ruby -w

require 'lib/gosu.for_1_8.bundle'

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
  end

  # 60 times per second
  def update
  end

  # happens immediately after each iteration of the update method
  def draw
  end

  def button_down(id)
    close if id == Gosu::KbQ
  end
end

window = GameWindow.new
window.show

