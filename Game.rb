require 'chingu'

class Game < Chingu::Window

	# Constructor
	def initialize
		super
		self.input = {esc: :exit}
	end
end

Game.new.show