module ATD
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
		def self.all
			Path.paths[App.path_info].action.call unless Path.paths[App.path_info].action == nil
		end
	end

	module Renderers
		@@permisible_filetypes = ["html", "css"]
		##
		# As input it takes a filename, checks if it's in the assets folder, then parses it using the other methods in ATD::Renderers and once it reaches the last extension, returns it and also finds the mime_type.
		def self.parse(filename)
			mime_type = "text/plain"
			file = filename
			if File.exists?("./assets/#{Validations.assets_folder(filename)}")
				file = File.read("./assets/#{Validations.assets_folder(filename)}")
				filename.split(".").reverse.each do |i|
					break unless @@permisible_filetypes.include? i
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

		def css(file)
			return file.gsub(/(\s|\t|\n)/,"")
		end
	end
end