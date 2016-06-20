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

end