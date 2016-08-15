require "rack"
require_relative "atd/server.rb"
require_relative "atd/path.rb"
require_relative "atd/handlers.rb"
require_relative "atd/helpers.rb"
require_relative "version.rb"

##
# The container for ATD. This allows everything to be refrenced through ATD::Something.something
module ATD

	##
	# This module is responsible for validating all of the file paths which are used in the app.
	module Validations
		##
		# This checks if a file name is using `..` to back out, which would allow access to any files on the system
		def self.assets_folder(file_name)
			return file_name.gsub(/(.\.\.|[^a-zA-Z0-9\.\\\/\-])/,"")
		end
	end

	##
	# Manages the server, for example starting the server. For now, all it does is start the server.
	
	class Server

		@@started = false

		def self.started?
			@@started
		end
		##
		# Creates routes for all the assets, then starts a server.
		def initialize(server = "WEBrick",port = 3150)
			ATD::App::Assets.new
			@@started = true
			Rack::Server.start(:app =>ATD::App, :server => server, :Port => port)
		end
	end

end

##
# Adds relevant methods to Object for easy access
class Object
	include ATD::App::Verbs
	include ATD::Helpers
end

at_exit do
	ATD::Server.new
end