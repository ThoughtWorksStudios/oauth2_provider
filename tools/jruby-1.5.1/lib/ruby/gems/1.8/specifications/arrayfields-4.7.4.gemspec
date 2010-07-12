# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{arrayfields}
  s.version = "4.7.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ara T. Howard"]
  s.date = %q{2009-06-04}
  s.email = %q{ara.t.howard@gmail.com}
  s.files = ["arrayfields.gemspec", "gemspec.rb", "install.rb", "lib", "lib/arrayfields.rb", "README", "readme.rb", "sample", "sample/a.rb", "sample/b.rb", "sample/c.rb", "sample/d.rb", "sample/e.rb", "test", "test/arrayfields.rb", "test/memtest.rb"]
  s.homepage = %q{http://github.com/ahoward/arrayfields/tree/master}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{codeforpeople}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{arrayfields}
  s.test_files = ["test/arrayfields.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
