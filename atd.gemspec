Gem::Specification.new do |s|
  s.name        = 'atd'
  s.version     = '0.0.3'
  s.date        = '2016-04-31'
  s.summary     = "A gem with the simplicity of sinatra, but the scalability of rails."
  s.description = "Allow this gem to give your gem some direction with it's easy to use 1 line method, and asset parsing/precompilation. Also, it's beautiful smoke test."
  s.authors     = ["Isaiah Zwick-Schachter"]
  s.email       = 'izwick.schachter@gmail.com'
  # s.files       = ["lib/atd.rb", "assets/bg.png", "assets/companyname.website.html"]
  s.files       = ["lib/atd.rb"]+Dir["assets/*"]
  s.homepage    =
    'https://github.com/izwick-schachter/atd'
  s.license       = 'MIT'
  s.executables = ["atd"]
  s.add_runtime_dependency "rack", "~> 1.6"
  s.add_runtime_dependency "jewel", "~> 0.0"
end