module ATD
	##
	# Manages all the initally created paths.
	# They're all stored here, and this class is queried by the ATD::App.call (rack server) to check if a path exists
	class Path
		@@paths = []

		@asset = false
		@headers = nil
		@action = nil
		@method = nil
		@output = nil

		attr_reader :headers, :action, :method, :output, :asset

		##
		# Initializes a path, saving them all in class variables and also manages duplicates.
		def initialize(path, headers, action, method, output, asset = false)
			if !Path[method,path].empty? && !asset
				puts "Warning: You have conflicting routes. Only the first one will be kept. "
			else
				if !asset || Path[method,path].empty?
					puts "Path #{path} initialized"
					unless ATD::Renderers.permisible_filetypes.include? output.split(".").last.to_sym
						puts "WARNING: The file extension #{output.split(".").last} on the output #{if !asset then "the route" end} #{output} does not have a renderer. It will be rendered with mime_type text/plain."
					end
					@asset = asset
					@headers = headers #Why...?
					@action = action # http meth
					@method = method # code
					if output.end_with?(".")
						old = output
						(Dir.entries("assets/") - [".", ".."]).each do |i|
							output = i if i.start_with? output
						end
						puts "Changed output from #{old} to #{output}"
					end
					@output = Renderers.parse(output)
					@@paths.push [path, method, self]
				else
					puts "Asset #{path} skipped"
				end
			end
		end

		##
		# Returns an instance of path corresponding to the method or path inputted. If either of them is nil, it returns an arry of the format [[path,method,instance],[path,method,instance]] which includes all the paths
		
		def self.paths
			@@paths
		end
		def paths.[](arg1=nil,arg2=nil)
			Path[arg1,arg2]
		end
		#			GET			/
		def self.[](method=nil,path = nil)
			return @@paths if path.nil? && method.downcase.to_sym.nil?
			if path.nil?
				paths = @@paths.select{|spath,smethod,sinst| method.downcase.to_sym==smethod}
			elsif method.nil?
				paths = @@paths.select{|spath,smethod,sinst| method.downcase.to_sym==smethod}
			else
				paths = @@paths.select{|spath,smethod,sinst| method.downcase.to_sym==smethod && path==spath}
			end
			final=[]

			paths.each{|path| final.push path[2]}
			return final
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

			module Routes
				class << self
					Verbs.allowed_verbs.each do |name|
						define_method(name.to_s) do |routes_hash|
							routes_hash.each do |route,asset|
								ATD::Path.new(route,nil,nil,:get,asset,false)
							end
						end
					end
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