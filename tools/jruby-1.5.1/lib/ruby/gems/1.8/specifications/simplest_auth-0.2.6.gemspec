# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{simplest_auth}
  s.version = "0.2.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tony Pitale"]
  s.date = %q{2009-12-20}
  s.email = %q{tony.pitale@viget.com}
  s.files = ["README.textile", "Rakefile", "lib/simplest_auth/controller.rb", "lib/simplest_auth/model.rb", "lib/simplest_auth/version.rb", "lib/simplest_auth.rb", "test/unit/simplest_auth/ar_model_test.rb", "test/unit/simplest_auth/controller_test.rb", "test/unit/simplest_auth/dm_model_test.rb", "test/unit/simplest_auth/model_test.rb"]
  s.homepage = %q{http://viget.com/extend}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Simple implementation of authentication for Rails}
  s.test_files = ["test/unit/simplest_auth/ar_model_test.rb", "test/unit/simplest_auth/controller_test.rb", "test/unit/simplest_auth/dm_model_test.rb", "test/unit/simplest_auth/model_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<bcrypt-ruby>, ["~> 2.1.1"])
    else
      s.add_dependency(%q<bcrypt-ruby>, ["~> 2.1.1"])
    end
  else
    s.add_dependency(%q<bcrypt-ruby>, ["~> 2.1.1"])
  end
end
