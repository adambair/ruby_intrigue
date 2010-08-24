#!/usr/bin/env ruby -w

require 'lib/gosu.for_1_8.bundle'
require 'lib/player'
require 'lib/asteroid'

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    @background_image = Gosu::Image.new(self, "assets/background.png", true)
    @player = Player.new(self)
    @asteroids = Asteroid.spawn(self, 3)
  end

  # 60 times per second
  def update
    control_player
    @player.move
    @asteroids.each{|asteroid| asteroid.move}
  end

  # happens immediately after each iteration of the update method
  def draw
    @background_image.draw(0, 0, 0)
    @player.draw
    @asteroids.each{|asteroid| asteroid.draw}
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
    if button_down? Gosu::KbUp
      @player.accelerate
    end
  end
end

window = GameWindow.new
window.show

