# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'feedback/version'

Gem::Specification.new do |gem|
  gem.name          = "feedback"
  gem.version       = Feedback::VERSION
  gem.authors       = ["Peter Wong"]
  gem.email         = ["dohkoos@gmail.com"]
  gem.description   = %q{feedback plugin for web frameworks}
  gem.summary       = %q{feedback provides your app an ajax-based feedback form triggered by a sticky tab.}
  gem.homepage      = "https://github.com/dohkoos/feedback"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
