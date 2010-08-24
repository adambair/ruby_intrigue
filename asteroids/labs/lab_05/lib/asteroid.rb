class Asteroid
  def initialize(window)
    @image = Gosu::Image.new(window, 'assets/asteroid-large-1.png', false)
    @x, @y, @angle = rand(640), rand(240), rand(360)
    @speed_modifier = 2
  end

  def draw
    @image.draw_rot(@x, @y, 0, @angle)
  end

  def move
    @x += @speed_modifier*Math.sin(Math::PI/180*@angle)
    @y += -@speed_modifier*Math.cos(Math::PI/180*@angle)
    @x %= 640
    @y %= 480
  end

  def hitbox
    hitbox_x = ((@x - @image.width/2).to_i..(@x + @image.width/2.to_i)).to_a
    hitbox_y = ((@y - @image.width/2).to_i..(@y + @image.width/2).to_i).to_a
    {:x => hitbox_x, :y => hitbox_y}
  end

  def self.spawn(window, count=3)
    3.times.collect{Asteroid.new(window)}
  end
end
