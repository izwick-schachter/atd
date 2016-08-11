module ATD::Renderer::Compiler
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