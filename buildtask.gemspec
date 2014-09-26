# -*- encoding: utf-8 -*-
require File.expand_path('../lib/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Paul Chechetin"]
  gem.email         = ["paulche@yandex.ru"]
  gem.description   = %q{RPM build Rake task}
  gem.summary       = %q{RPM build Rake task}
  gem.homepage      = "https://github.com/paulche/buildtask"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "buildtask"
  gem.require_paths = ["lib"]
  gem.version       = BuildTask::VERSION

  gem.add_dependency('rake')
end
