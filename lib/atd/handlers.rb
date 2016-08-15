module ATD

	##
	# This class takes a file and parses it to a string including parsing the file extension and optimizing the files.
	class App::Path::Renderer

		# The result of a renderer
		attr_reader :output
		##
		# As input it takes a filename, checks if it's in the assets folder, then parses it using the other methods in ATD::Renderers and once it reaches the last extension, returns it and also finds the mime_type.
		def initialize(filename, mime_type = "text/plain")
			file = filename
			if File.exists?("./assets/#{Validations.assets_folder(filename)}")
				filename.split(".").reverse.each do |i|
					if ATD::Server.started?
						break unless Compiler.permisible_filetypes.include? i.to_sym
						file = File.read("./assets/#{Validations.assets_folder(filename)}")
						details = Compiler.send("#{i}",file)
					else
						break unless Precompiler.permisible_filetypes.include? i.to_sym
						file = File.read("./assets/#{Validations.assets_folder(filename)}")
						details = Precompiler.send("#{i}",file)
					end
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

		module Precompiler
			extend self
			# Lists the filetypes that are accepted as all the methods in this class. These can be added to in accordance with README.md.
			def self.permisible_filetypes
				self.instance_methods(false)
			end
		end

		module Compiler
			extend self
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

	module Renderer
		module Compiler
			extend App::Path::Renderer::Compiler
		end
		module Precompiler
			extend App::Path::Renderer::Precompiler
		end
	end

end	