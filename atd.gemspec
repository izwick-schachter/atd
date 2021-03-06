require_relative "lib/version.rb"

Gem::Specification.new do |s|
  s.name        = 'atd'
  s.version     = ATD.version
  s.date        = '2016-04-31'
  s.summary     = "A gem with the simplicity of sinatra, but the scalability of rails."
  s.description = "Allow this gem to give your web app some direction with easy, 1 line hello world routes, asset precompilation, and xkcd inspired smoke test."
  s.authors     = ["Isaiah Zwick-Schachter"]
  s.email       = 'izwick.schachter@gmail.com'
  s.files       = Dir["lib/*"]+Dir["lib/atd/*"]+Dir["assets/*/*"]
  s.homepage    =
    'https://github.com/izwick-schachter/atd'
  s.license       = 'MIT'
  s.executable = "atd"
  s.add_runtime_dependency "rack", "~> 1"
  s.add_development_dependency "rspec", "~> 3"
  s.add_development_dependency "rack-test", "~> 0"
  s.add_development_dependency "test-unit", "~> 3"
end