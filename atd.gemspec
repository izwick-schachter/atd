Gem::Specification.new do |s|
  s.name        = 'atd'
  s.version     = '0.0.3'
  s.date        = '2016-04-31'
  s.summary     = "A gem with the simplicity of sinatra, but the scalability of rails."
  # s.description = "A gem with the simplicity of sinatra, but the scalability of rails."
  s.authors     = ["Isaiah Zwick-Schachter"]
  s.email       = 'izwick.schachter@gmail.com'
  s.files       = ["lib/atd.rb"]
  s.homepage    =
    'https://github.com/izwick-schachter/atd'
  s.license       = 'MIT'
  s.executables = ["atd"]
  s.add_runtime_dependency "rack", "~> 1.6"
end