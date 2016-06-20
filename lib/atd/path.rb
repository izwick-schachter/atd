module ATD
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
				return nil if !Dir.exists? "assets"
				(Dir.entries("assets")-["..","."]).each do |i|
					ATD::Path.new("/#{i}",nil,nil,:get,i,true)
				end
			end
		end
	end
end