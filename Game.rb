require 'Chingu'

class Game < Chingu::Window

	# Constructor
	def initialize
		super 640, 480
		self.caption = "Into Space"
		self.input = {esc: :exit}
		@background_image = Background.create
		@player = Player.create
		@asteroid = Asteroide.create
	end
end

class Background < Chingu::GameObject
	def setup
		@x = 640/2
		@y = 480/2
		@image = Gosu::Image["galaxy.jpg"]
	end
end

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
		self.velocity_x *= 0.92
		self.velocity_y *= 0.92
	end

	def left
		unless @x - image.width/2 <= 0
			@angle -= 4
		end
	end

	def right
		unless @x + image.width/2 >=800
			@angle += 4
		end
	end

	def up
		self.velocity_x += Gosu::offset_x(@angle, 0.5)
		self.velocity_y += Gosu::offset_y(@angle, 0.5)
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

class Laser < Chingu::GameObject
	has_traits :velocity, :timer

	def setup
		@image = Gosu::Image["lazer.png"]
		self.velocity_y = Gosu::offset_y(angle, 10)
		self.velocity_x = Gosu::offset_x(angle, 10)
		after(1000) {self.destroy}
	end
end

class Asteroide < Chingu::GameObject
	has_traits :velocity


	def setup
		@x, @y = 100, 100
		@image = Gosu::Image["asteroid.png"]

		#@speed = [1,2,3]

		#@speed_rand = rand(speed.size)

		self.velocity_y = Gosu::offset_y(angle, 2 )#@speed_rand)
		self.velocity_x = Gosu::offset_x(angle, 2 )#@speed_rand)
	end

	def update
		@x %= 640
		@y %= 480
	end
end

Game.new.show