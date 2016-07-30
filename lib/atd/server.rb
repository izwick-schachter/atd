module ATD

	class App

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
			puts "EXPRESSION: Path[#{env["REQUEST_METHOD"].downcase.to_sym}, #{env["PATH_INFO"]}] == #{Path[env["REQUEST_METHOD"].downcase, env["PATH_INFO"]]}"
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
				ATD::Request.set(env)
				output = RequestHandlers.route(env["REQUEST_METHOD"],env["PATH_INFO"])
				#ATD::Request.get(env)
				##
				# 3. Converts ouput to a usable rack ouput
				if output[:"content-type"].nil?
					status_code = 204
				else
					headers["content-type"] = output[:"content-type"]
					page.push(output[:content])
				end
			end
			##
			# Returns the resulting packet
			puts [status_code, headers, page].to_s
			return [status_code, headers, page]
		end
	end

end