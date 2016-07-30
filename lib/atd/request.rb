module ATD::Request
	def self.set(env)
		req = Rack::Request.new(env)
		Object.instance_variable_set("@params", req.params)
	end
	def self.get(env)
		req = Rack::Request.new(env)
		req.params = Object.instance_variable_get("@params")
	end
end