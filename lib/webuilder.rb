require "rack"
require "webrick"

# TODO: Add asset pipeline
# TODO: Test Driven Development
# TODO: Test how well actions within routes work

module Webuilder

	class App

		##
		# Allows Webuilder::RequestHandlers to access env["PATH_INFO"]

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
				# 1. Sets @@path_info to env["PATH_INFO"] for use in Webuilder::RequestHandlers
				@@path_info = env["PATH_INFO"]
				##
				# 2. Sets ouput to wherever Webuilder::RequestHandlers returns from RequestHandlers.get / .post call
				output = RequestHandlers.public_send(Path.paths[env["PATH_INFO"]].method) if [:get, :post].include? Path.paths[env["PATH_INFO"]].method.downcase
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
	# They're all stored here, and this class is queried by the Webuilder::App.call (rack server) to check if a path exists
	class Path
		@@paths = {}

		@headers = nil
		@action = nil
		@method = nil
		@output = nil

		attr_reader :headers, :action, :method, :output

		def initialize(path, headers, action, method, output)
			puts "Path #{path} initialized"
			@headers = headers #Why...?
			@action = action # http meth
			@method = method # code
			@output = output
			@@paths[path] = self
		end

		##
		# Returns all the paths that exist. Queried by the Webuilder::App.call (rack server)

		def self.paths
			@@paths
		end

		module Verbs
			[:get, :post].each do |name|
				define_method(name) do |path, output = "Hello World!", headers = nil, &block|
					Webuilder::Path.new(path,headers,block,name,output)
				end
			end
		end
	end

	module RequestHandlers
		def self.get
			all
			if !Path.paths[App.path_info].output.is_a?(Hash)
				return {:"content-type" => "text/plain", :content => Path.paths[App.path_info].output}
			else
				return Path.paths[App.path_info].output
			end
		end

		def self.post
			all
		end

		def self.all
			Path.paths[App.path_info].action.call unless Path.paths[App.path_info].action == nil
		end
	end

	module Renderers
		def html(file)
			return {:content => File.read("./public/"+Validations.public_folder(file)), :"content-type" => "text/html"}
		end
	end

	##
	# This class is responsible for validating all of the file paths which are used in the app
	module Validations
		##
		# This checks if a file name is using `..` to back out, which would allow access to any files on the system
		def self.public_folder(file_name)
			return file_name.gsub(/(.\.\.|[^a-zA-Z0-9\.\\\/\-])/,"")
		end
	end

	##
	# Manages the (currently only webrick) server
	
	module Server
		def start
			Rack::Server.start(:app =>Webuilder::App, :server => WEBrick)
		end

		def stop
			Rack::Server.stop
		end
	end


end

##
# Adds relevant methods to Object for easy access
class Object
	include Webuilder::Path::Verbs
	include Webuilder::Renderers
	include Webuilder::Server
	include Webuilder::Request
end