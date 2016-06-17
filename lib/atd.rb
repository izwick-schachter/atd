require "rack"

# TODO: Add asset pipeline
# TODO: Test Driven Development
# TODO: Test how well actions within routes work

module ATD

	class App

		##
		# Allows ATD::RequestHandlers to access env["PATH_INFO"]

		def self.path_info
			@@path_info
		end

		##
		# The real rack app

		def self.call(env)
			##
			# Set default values for a default page (by default empty plaintext page)
			page = []
			headers = {}
			status_code = 200
			##
			# Checks if a path doesn't exist. If it doesn't exist return 404
			if Path.paths[env["PATH_INFO"]].nil?
				page.push("404 Error: Path Not Found")
				status_code = 404
			else
				##
				# Otherwise
				##
				# 1. Sets @@path_info to env["PATH_INFO"] for use in ATD::RequestHandlers
				@@path_info = env["PATH_INFO"]
				##
				# 2. Sets ouput to wherever ATD::RequestHandlers returns from RequestHandlers.get / .post call
				output = RequestHandlers.public_send(Path.paths[env["PATH_INFO"]].method) if Path::Verbs.allowed_verbs.include? Path.paths[env["PATH_INFO"]].method.downcase
				##
				# 3. Converts ouput to a usable rack ouput
				headers["content-type"] = output[:"content-type"]
				page.push(output[:content])
			end
			##
			# Returns the resulting packet
			return [status_code, headers, page]
		end
	end

	##
	# Manages all the initally created paths.
	# They're all stored here, and this class is queried by the ATD::App.call (rack server) to check if a path exists
	class Path
		@@paths = {}

		@asset = false
		@headers = nil
		@action = nil
		@method = nil
		@output = nil

		attr_reader :headers, :action, :method, :output, :asset

		##
		# Initializes a path, saving them all in class variables and also manages duplicates.
		def initialize(path, headers, action, method, output, asset = false)
			puts "PREV PATH: #{@@paths[path]}"
			if !@@paths[path].nil? && !asset
				puts "Warning: You have conflicting routes. Only the first one will be kept. "
			else
				if !asset || @@paths[path].nil?
					puts "Path #{path} initialized"
					@asset = asset
					@headers = headers #Why...?
					@action = action # http meth
					@method = method # code
					@output = Renderers.parse(output)
					puts "@output: #{@output}"
					@@paths[path] = self
				else
					puts "Asset #{path} skipped"
				end
			end
		end

		##
		# Returns all the paths that exist. Queried by the ATD::App.call (rack server)

		def self.paths
			@@paths
		end

		##
		# Manages the creation of verb methods for use in the main method to create various paths
		module Verbs
			@@allowed_verbs = [:get, :post]

			##
			# Returns an array of the allowed http verbs as symbols (e.g. :get, :post)
			def self.allowed_verbs
				@@allowed_verbs
			end

			##
			# Defines a methos for each http verb that creats an instance of ATD::Path for it
			@@allowed_verbs.each do |name|
				define_method(name) do |path, output = "Hello World!", headers = nil, &block|
					ATD::Path.new(path,headers,block,name,output)
				end
			end
		end

		##
		# Allows ATD::Server's start method to compile the static assets into routes
		module Assets

			##
			# Takes all the files in the assets directory and creates routes from them
			def self.setup
				(Dir.entries("assets")-["..","."]).each do |i|
					ATD::Path.new("/#{i}",nil,nil,:get,i,true)
				end
			end
		end
	end

	##
	# This module is responsible for delegating http verb unique parsing methods. Currently doesn't do much.
	module RequestHandlers

		##
		# Processes get routes. Returns either the filename or plaintext output, and sends it back to ATD::App, where it is then sent to ATD::Renerers.
		# The call could be shorter if you skiped the sending to ATD::App and just sent the ouput streight to ATD::Renderers.
		def self.get
			all
			if !Path.paths[App.path_info].output.is_a?(Hash)
				return {:"content-type" => "text/plain", :content => Path.paths[App.path_info].output}
			else
				return Path.paths[App.path_info].output
			end
		end

		##
		# Processes post routes. It currently just processes the action by calling all
		def self.post
			all
		end

		##
		# Because all paths need their action called, so this method does it, and is called by all the other ATD::RequestHandlers
		def all
			Path.paths[App.path_info].action.call unless Path.paths[App.path_info].action == nil
		end
	end

	module Renderers

		##
		# As input it takes a filename, checks if it's in the assets folder, then parses it using the other methods in ATD::Renderers and once it reaches the last extension, returns it and also finds the mime_type.
		def self.parse(filename)
			mime_type = "text/plain"
			file = filename
			if File.exists?("./assets/#{Validations.assets_folder(filename)}")
				file = File.read("./assets/#{Validations.assets_folder(filename)}")
				filename.split(".").reverse.each do |i|
					break unless ["html"].include? i
					file = send("#{i}",file)
					mime_type = "text/#{i}"
				end
			end
			return {:content => file, :"content-type" => mime_type}
		end

		##
		# Parses an html file (in this case, there is nothing to be parsed, it simply returns an html file.)
		def html(file)
			return file
		end
	end

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