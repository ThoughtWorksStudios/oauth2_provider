# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ruby2ruby}
  s.version = "1.2.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ryan Davis"]
  s.date = %q{2009-08-14}
  s.default_executable = %q{r2r_show}
  s.description = %q{ruby2ruby provides a means of generating pure ruby code easily from
RubyParser compatible Sexps. This makes making dynamic language
processors in ruby easier than ever!}
  s.email = ["ryand-ruby@zenspider.com"]
  s.executables = ["r2r_show"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = [".autotest", "History.txt", "Manifest.txt", "README.txt", "Rakefile", "bin/r2r_show", "lib/ruby2ruby.rb", "test/test_ruby2ruby.rb"]
  s.homepage = %q{http://seattlerb.rubyforge.org/}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{seattlerb}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{ruby2ruby provides a means of generating pure ruby code easily from RubyParser compatible Sexps}
  s.test_files = ["test/test_ruby2ruby.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sexp_processor>, ["~> 3.0"])
      s.add_runtime_dependency(%q<ruby_parser>, ["~> 2.0"])
      s.add_development_dependency(%q<ParseTree>, ["~> 3.0"])
      s.add_development_dependency(%q<hoe>, [">= 2.3.3"])
    else
      s.add_dependency(%q<sexp_processor>, ["~> 3.0"])
      s.add_dependency(%q<ruby_parser>, ["~> 2.0"])
      s.add_dependency(%q<ParseTree>, ["~> 3.0"])
      s.add_dependency(%q<hoe>, [">= 2.3.3"])
    end
  else
    s.add_dependency(%q<sexp_processor>, ["~> 3.0"])
    s.add_dependency(%q<ruby_parser>, ["~> 2.0"])
    s.add_dependency(%q<ParseTree>, ["~> 3.0"])
    s.add_dependency(%q<hoe>, [">= 2.3.3"])
  end
end
