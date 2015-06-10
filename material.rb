# defino una clase material con los datos necesarios
require_relative 'color'

class Material
	attr_accessor :name
	attr_accessor :diffuse
	attr_accessor :specular
	attr_accessor :shininess
	attr_accessor :texture
	attr_accessor :texture_image
	attr_accessor :texture_width
	attr_accessor :texture_height

	def initialize(name)
		@name = name
		@diffuse = Color.new
		@specular = Color.new
		@shinniness = 0.0
		@texture = nil
		@texture_image = nil
	end
end