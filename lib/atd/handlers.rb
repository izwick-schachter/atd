module ATD
	##
	# This module is responsible for delegating http verb unique parsing methods. Currently doesn't do much.
	module RequestHandlers

		def self.route(verb, path)
			return {:"content-type" => "text/plain", :content => "Error"} if !Path::Verbs.allowed_verbs.include? verb.downcase.to_sym
			@@path_info = path
			@@path = Path[verb,path]
			send(verb.downcase)
		end

		##
		# Processes get routes. Returns either the filename or plaintext output, and sends it back to ATD::App, where it is then sent to ATD::Renerers.
		# The call could be shorter if you skiped the sending to ATD::App and just sent the ouput streight to ATD::Renderers.
		def self.get
			all
			{:"content-type" => "text/plain", :content => @@path[0].output} if !@@path[0].output.is_a?(Hash)
			@@path[0].output
		end

		##
		# Processes post routes. It currently just processes the action by calling all
		def self.post
			all
			return {:"content-type" => nil, :content => nil}
		end

		##
		# Because all paths need their action called, so this method does it, and is called by all the other ATD::RequestHandlers
		def self.all
			paths = @@path[0]
			paths.action.call unless paths.nil? || paths.action.nil?
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
					break unless Renderers.permisible_filetypes.include? i.to_sym
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
			return {:content => file, :"content-type" => mime_type}
		end

		def self.permisible_filetypes
			Renderers.instance_methods
		end

		##
		# Parses an html file (in this case, there is nothing to be parsed, it simply returns an html file.)
		def html(file)
			return file
		end

		def css(file)
			return file.gsub(/(\t|\n)/,"")
		end

		def js(file)
			return file
		end
		
	end
end