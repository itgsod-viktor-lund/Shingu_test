require 'Chingu'

class Game < Chingu::Window

	# Constructor
	def initialize
		super 640, 480
		self.input = {esc: :exit}
		@background_image = Background.create
		@player = Player.create
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
	
	# meta-constructor
	def setup
		@x, @y = 350, 400
		@speed = 5
		@angle = 0
		@image = Gosu::Image["ship.png"]
		self.input = {
			holding_left: :left,
			holding_right: :right,
			holding_up: :up,
			holding_down: :down,
			holding_space: :fire
		}
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
		unless @y - image.width/2 <= 0
			@y -= @speed
		end
	end

	def down
		unless @y + width/2 >= 480
			@y += @speed
		end
	end

	def fire
		Laser.create(x: self.x, y: self.y, angle: self.angle)
	end
end

class Laser < Chingu::GameObject
	has_traits :velocity

	def setup
		@image = Gosu::Image["lazer.png"]
		self.velocity_y = Gosu::offset_y(angle, 15)
		self.velocity_x = Gosu::offset_x(angle, 15)
	end
end

Game.new.show