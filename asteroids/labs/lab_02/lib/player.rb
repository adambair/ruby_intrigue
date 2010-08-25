class Player
  def initialize(window)
    @image = Gosu::Image.new(window, 'assets/ship.png', false)
    @angle = 0.0
    @x, @y = 320, 240
  end

  def draw
    @image.draw_rot(@x, @y, 0, @angle)
  end

  def turn_left
    @angle -= 4.5
  end

  def turn_right
    @angle += 4.5
  end
end
