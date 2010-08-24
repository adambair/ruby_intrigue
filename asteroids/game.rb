#!/usr/bin/env ruby -w

require 'lib/gosu.for_1_8.bundle'

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
  end
end

window = GameWindow.new
window.show

