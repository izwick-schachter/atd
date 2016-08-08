class ATD::Request
	attr_accessor :request, :response, :env

	def initialize(env)
		@env = env
		@request = Rack::Request.new(env)
		@response = Rack::Response.new(env)
	end

	def setrequest(newval)
		puts "Setting ATD::Request.request to #{newval}"
		a=Rack::Request.new(@env)
		a.params[:test] = "reslust"
	end

	def getrequest
		puts "Getting Request"
		a=Rack::Request.new(@env)
		puts a.params
	end
end