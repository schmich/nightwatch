require File.expand_path('lib/nightwatch/version.rb', File.dirname(__FILE__))

Gem::Specification.new do |s|
  s.name = 'nightwatch'
  s.version = Nightwatch::VERSION
  s.bindir = 'bin'
  s.executables = ['nightwatch']
  s.date = Time.now.strftime('%Y-%m-%d')
  s.summary = 'Ruby exception monitor.'
  s.description = 'Ruby exception monitor.'
  s.authors = ['Chris Schmich']
  s.email = 'schmch@gmail.com'
  s.files = Dir['{lib}/**/*', 'bin/*', '*.md']
  s.require_path = 'lib'
  s.homepage = 'https://github.com/schmich/nightwatch'
  s.license = 'MIT'
  s.required_ruby_version = '>= 1.9.3'
  s.add_runtime_dependency 'sinatra', '~> 1.4'
  s.add_runtime_dependency 'sinatra-contrib', '~> 1.4'
  s.add_runtime_dependency 'mongo', '~> 1.11'
  s.add_runtime_dependency 'thor', '~> 0.19'
  s.add_runtime_dependency 'thin', '~> 1.4'
  s.add_runtime_dependency 'deep_merge', '~> 1.0'
  s.add_development_dependency 'rake', '~> 10.3'
end
