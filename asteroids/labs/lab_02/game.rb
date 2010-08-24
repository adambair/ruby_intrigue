#!/usr/bin/env ruby -w

require 'lib/gosu.for_1_8.bundle'
require 'lib/player'

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    @background_image = Gosu::Image.new(self, "assets/background.png", true)
    @player = Player.new(self)
  end

  # 60 times per second
  def update
    control_player
    # puts 'testing game loop...'
  end

  # happens immediately after each iteration of the update method
  def draw
    @background_image.draw(0, 0, 0)
    @player.draw
  end

  def button_down(id)
    close if id == Gosu::KbQ
  end

  def control_player
    if button_down? Gosu::KbLeft
      @player.turn_left
    end
    if button_down? Gosu::KbRight
      @player.turn_right
    end
  end
end

window = GameWindow.new
window.show

