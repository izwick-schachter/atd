class ATD::Request
	attr_accessor :request, :response

	def initialize(env)
		@request = Rack::Request.new(env)
		@response = Rack::Response.new(env)
	end
end