# frozen_string_literal: true

require_relative 'lib/sumaki/version'

Gem::Specification.new do |spec|
  spec.name = 'sumaki'
  spec.version = Sumaki::VERSION
  spec.authors = ['Loose Coupling']
  spec.email = ['loosecpl@gmail.com']

  spec.summary = 'Sumaki is a wrapper for structured data like JSON.'
  spec.description = <<~DESC
    Sumaki is a wrapper for structured data like JSON.
    Since Sumaki wraps the target data as it is, rather than parsing it using a schema, the original data can be referenced at any time.
    This makes it easy to add or modify definitions as needed while checking the target data.
    This feature may be useful when there is no document defining the structure of the data, or when the specification is complex and difficult to grasp, and the definition is written little by little starting from the obvious places.
  DESC
  spec.homepage = 'https://github.com/nowlinuxing/sumaki/'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org/'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = spec.homepage
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_runtime_dependency 'minenum'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
