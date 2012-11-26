require 'Chingu'

# Creating the game window
class Game < Chingu::Window

	# Constructor
	def initialize
		super 640, 480
		self.caption = "Into Space"
		self.input = {esc: :exit}
		@background_image = Background.create
		@player = Player.create
		@asteroide = []
		10.times {@asteroide << Asteroide.create}
		@index = 10
		
	end

	def update
		super
		Laser.each_bounding_circle_collision(Asteroide) do |laser, asteroide|
      		@index -= 1
      		laser.destroy
      		asteroide.destroy
    	end
		if @index == 0
			@background_image.destroy
			@background_image = Victory.create		
		end
	end
end

# Creating the background
class Background < Chingu::GameObject
	
	def setup
		@x = 640/2
		@y = 480/2
		@image = Gosu::Image["galaxy.jpg"]
	end
end

# Creating the victory image
class Victory < Chingu::GameObject

	def setup
		@zorder = 300
		@x = 640/2
		@y = 480/2
		@image = Gosu::Image["victory.png"]
	end
end

# Creating the player
class Player < Chingu::GameObject
	has_traits :velocity

	# meta-constructor
	def setup
		@x, @y = 640/2, 480/2
		@angle = 0
		@image = Gosu::Image["ship.png"]
		
		self.input = {
			holding_left: :left,
			holding_right: :right,
			holding_up: :up,
			holding_down: :down,
			space: :fire
		}
	end

	def update
		@x %= 640
		@y %= 480
		self.velocity_x *= 0.98
		self.velocity_y *= 0.98
	end

	def left
		unless @x - image.width/2 <= 0
			@angle -= 5
		end
	end

	def right
		unless @x + image.width/2 >=800
			@angle += 5
		end
	end

	def up
		self.velocity_x += Gosu::offset_x(@angle, 0.5)
		self.velocity_y += Gosu::offset_y(@angle, 0.5)

		self.velocity_x *= 0.92
		self.velocity_y *= 0.92
	end

	def down
		self.velocity_x -= Gosu::offset_x(@angle, 0.5)
		self.velocity_y -= Gosu::offset_y(@angle, 0.5)
		self.velocity_x *= 0.80
		self.velocity_y *= 0.80
	end

	def fire
		Laser.create(x: self.x, y: self.y, angle: self.angle)
	end
end

# Creating the laser shot
class Laser < Chingu::GameObject
	has_traits :velocity, :timer, :collision_detection, :bounding_circle

	def setup
		@image = Gosu::Image["lazer.png"]
		self.velocity_y = Gosu::offset_y(angle, 15)
		self.velocity_x = Gosu::offset_x(angle, 15)
		after(2500) {self.destroy}
	end
end

# Creating the asteroides
class Asteroide < Chingu::GameObject
	has_traits :velocity, :collision_detection, :bounding_circle

	def setup
		@x, @y = rand(640), rand(480)
		angle = rand(360)
		speed = rand(1...4)
		self.factor = rand(1...3)
		@image = Gosu::Image["asteroid.png"]


		self.velocity_y = Gosu::offset_y(angle, speed)
		self.velocity_x = Gosu::offset_x(angle, speed)
	end

	def update
		@x %= 640
		@y %= 480
	end
end

# Starts the game
Game.new.show