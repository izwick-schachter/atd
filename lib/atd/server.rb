module ATD

	##
	# The class containing the rack server. It delegates tasks out to other classes in parsing requests. It is responsible for sending out the final output and is called singularly by ATD::Server.
	class App

		##
		# Initializes the rack app. Called only from ATD::Server.new()

		def self.call(env)
			##
			# Set default values for a default page (by default empty plaintext page)
			page = []
			headers = {}
			status_code = 200
			##
			# Checks if a path doesn't exist. If it doesn't exist return 404
			if Path[env["REQUEST_METHOD"].downcase, env["PATH_INFO"]].empty?
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
				handler = RequestHandler.new(env["REQUEST_METHOD"],env["PATH_INFO"])
				puts handler.output.class
				##
				# 3. Converts ouput to a usable rack ouput
				if handler.output[:"content-type"].nil?
					status_code = 204
				else
					headers["content-type"] = handler.output[:"content-type"]
					page.push(handler.output[:content])
				end
			end
			##
			# Returns the resulting packet
			puts [status_code, headers, page].to_s
			return [status_code, headers, page]
		end

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
					if @@path[0].output.is_a?(Hash)
						renderer = ATD::Renderer.new(@@path[0].output[:content], @@path[0].output[:"content-type"])
						@output = renderer.output
					else
						@output = {:"content-type" => "text/plain", :content => @@path[0].output}
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
	end

end