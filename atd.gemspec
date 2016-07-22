require "./lib/version.rb"

Gem::Specification.new do |s|
  s.name        = 'atd'
  s.version     = ATD.version
  s.date        = '2016-04-31'
  s.summary     = "A gem with the simplicity of sinatra, but the scalability of rails."
  s.description = "Allow this gem to give your web app some direction with easy, 1 line hello world routes, asset precompilation, and xkcd inspired smoke test."
  s.authors     = ["Isaiah Zwick-Schachter"]
  s.email       = 'izwick.schachter@gmail.com'
  s.files       = Dir["lib/*"]+Dir["lib/atd/*"]+Dir["assets/*"]
  s.homepage    =
    'https://github.com/izwick-schachter/atd'
  s.license       = 'MIT'
  s.executables = ["atd"]
  s.add_runtime_dependency "rack", "~> 1.6"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rack-test"
end