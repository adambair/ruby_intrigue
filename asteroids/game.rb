#!/usr/bin/env ruby -w

require 'lib/*.rb'

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
  end
end

window = GameWindow.new
window.show

