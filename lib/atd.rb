require "rack"
require_relative "atd/path.rb"
require_relative "atd/server.rb"
require_relative "atd/handlers.rb"

# TODO: Add asset pipeline
# TODO: Test Driven Development
# TODO: Test how well actions within routes work
# TODO: Don't generate assets unless in an atd dir

module ATD

	##
	# This class is responsible for validating all of the file paths which are used in the app
	module Validations
		##
		# This checks if a file name is using `..` to back out, which would allow access to any files on the system
		def self.assets_folder(file_name)
			return file_name.gsub(/(.\.\.|[^a-zA-Z0-9\.\\\/\-])/,"")
		end
	end

	##
	# Manages the (currently only webrick) server
	
	module Server

		##
		# Creates routes for all the assets, then starts a WEBrick server.
		def start
			ATD::Path::Assets.setup
			Rack::Server.start(:app =>ATD::App, :server => WEBrick)
		end
	end

end

##
# Adds relevant methods to Object for easy access
class Object
	include ATD::Path::Verbs
	include ATD::Renderers
	include ATD::Server
end