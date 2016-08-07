module ATD
	##
	# This module is responsible for delegating http verb unique parsing methods. Currently doesn't do much.
	class RequestHandler

		# The output of a parsed file
		attr_reader :output

		##
		# Parses a file, and delegates parts to renderer.
		def initialize(verb, path)
			@output = {:"content-type" => "text/plain", :content => "Error"} if !Path::Verbs.allowed_verbs.include? verb.downcase.to_sym
			@@path_info = path
			@@path = Path[verb,path]
			case verb.downcase
			when "get"
				##
				# Processes get routes. Returns either the filename or plaintext output, and sends it back to ATD::App, where it is then sent to ATD::Renerers.
				# The call could be shorter if you skiped the sending to ATD::App and just sent the ouput streight to ATD::Renderers.
				all
				if !@@path[0].output.is_a?(Hash)
					@output = {:"content-type" => "text/plain", :content => @@path[0].output}
				else
					@output = @@path[0].output
				end
			when "post"
				##
				# Processes post routes. It currently just processes the action by calling all
				all
				@output =  {:"content-type" => nil, :content => nil}
			end
		end

		##
		# Because all paths need their action called, so this method does it, and is called by all the other ATD::RequestHandlers
		def all
			paths = @@path[0]
			paths.action.call unless paths.nil? || paths.action.nil?
		end
	end

	##
	# This class takes a file and parses it to a string including parsing the file extension and optimizing the files.
	class Renderer

		# The result of a renderer
		attr_reader :output
		##
		# As input it takes a filename, checks if it's in the assets folder, then parses it using the other methods in ATD::Renderers and once it reaches the last extension, returns it and also finds the mime_type.
		def initialize(filename)
			mime_type = "text/plain"
			file = filename
			if File.exists?("./assets/#{Validations.assets_folder(filename)}")
				file = File.read("./assets/#{Validations.assets_folder(filename)}")
				filename.split(".").reverse.each do |i|
					break unless Renderer.permisible_filetypes.include? i.to_sym
					details = send("#{i}",file)
					if details.class == Hash then
						file = details[:file]
						mime_type = details[:mime_type]
					else
						file = details
						mime_type = "text/#{i}"
					end
				end
			end
			@output = {:content => file, :"content-type" => mime_type}
		end

		# Lists the filetypes that are accepted as all the methods in this class. These can be added to in accordance with README.md.
		def self.permisible_filetypes
			self.instance_methods(false)
		end

		##
		# Parses an html file (in this case, there is nothing to be parsed, it simply returns an html file.)
		def html(file)
			return file
		end

		# Optimizes a css file
		def css(file)
			return file.gsub(/(\t|\n)/,"")
		end

		# Optimizes a js file
		def js(file)
			return file
		end
		
	end
end