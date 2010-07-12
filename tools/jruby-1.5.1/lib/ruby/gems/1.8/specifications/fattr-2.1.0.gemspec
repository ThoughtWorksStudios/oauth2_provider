# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{fattr}
  s.version = "2.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ara T. Howard"]
  s.date = %q{2009-10-11}
  s.description = %q{fattr.rb is a "fatter attr" for ruby}
  s.email = %q{ara.t.howard@gmail.com}
  s.files = ["a.rb", "fattr.gemspec", "lib/fattr.rb", "Rakefile", "README", "README.erb", "samples/a.rb", "samples/b.rb", "samples/c.rb", "samples/d.rb", "samples/e.rb", "samples/f.rb", "samples/g.rb", "samples/h.rb", "test/fattr.rb"]
  s.homepage = %q{http://github.com/ahoward/fattr/tree/master}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{codeforpeople}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{fattr}
  s.test_files = ["test/fattr.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
