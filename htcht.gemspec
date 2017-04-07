# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'htcht/version'

Gem::Specification.new do |spec|
  spec.name          = "htcht"
  spec.version       = Htcht::VERSION
  spec.authors       = ["Trim Agency"]
  spec.email         = ["info@trimagency.com"]

  spec.summary       = %q{The internal CLI of Trim Agency. Used to setup new projects, build, test, etc.}
  spec.homepage      = "https://github.com/TrimAgency/htcht"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = ["htcht"]
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 0.1"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency "aruba", '~> 0.14.2'
  spec.add_development_dependency "pry", '~> 0.10.4'
end
