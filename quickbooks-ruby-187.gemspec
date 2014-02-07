$:.unshift File.expand_path("../lib", __FILE__)
require "quickbooks/version"

Gem::Specification.new do |gem|
  gem.name     = "quickbooks-ruby-187"
  gem.version  = Quickbooks::VERSION

  gem.homepage = "http://github.com/troysurrett/quickbooks-ruby"
  gem.summary  = "REST API to Quickbooks Online via Intuit Data Services v3, forked to work with Ruby 1.8.7"
  gem.license  = 'MIT'
  gem.description = gem.summary

  gem.files = Dir['lib/**/*']

  gem.add_dependency 'oauth'
  gem.add_dependency 'roxml'
  gem.add_dependency 'nokogiri', '~> 1.5.0'
  gem.add_dependency 'activemodel', '3.1.12'
  gem.add_dependency 'json'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rr',     '~> 1.0.2'
  gem.add_development_dependency 'rspec',  '2.13.0'
  gem.add_development_dependency 'fakeweb'
end
