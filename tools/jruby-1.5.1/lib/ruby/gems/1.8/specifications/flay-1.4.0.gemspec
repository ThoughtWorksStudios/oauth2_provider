# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{flay}
  s.version = "1.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ryan Davis"]
  s.date = %q{2009-08-14}
  s.default_executable = %q{flay}
  s.description = %q{Flay analyzes code for structural similarities. Differences in literal
values, variable, class, method names, whitespace, programming style,
braces vs do/end, etc are all ignored. Making this totally rad.}
  s.email = ["ryand-ruby@zenspider.com"]
  s.executables = ["flay"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "bin/flay", "lib/flay.rb", "lib/flay_erb.rb", "lib/flay_task.rb", "lib/gauntlet_flay.rb", "test/test_flay.rb"]
  s.homepage = %q{http://ruby.sadi.st/}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{seattlerb}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Flay analyzes code for structural similarities}
  s.test_files = ["test/test_flay.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sexp_processor>, ["~> 3.0"])
      s.add_runtime_dependency(%q<ruby_parser>, ["~> 2.0"])
      s.add_development_dependency(%q<hoe>, [">= 2.3.3"])
    else
      s.add_dependency(%q<sexp_processor>, ["~> 3.0"])
      s.add_dependency(%q<ruby_parser>, ["~> 2.0"])
      s.add_dependency(%q<hoe>, [">= 2.3.3"])
    end
  else
    s.add_dependency(%q<sexp_processor>, ["~> 3.0"])
    s.add_dependency(%q<ruby_parser>, ["~> 2.0"])
    s.add_dependency(%q<hoe>, [">= 2.3.3"])
  end
end
