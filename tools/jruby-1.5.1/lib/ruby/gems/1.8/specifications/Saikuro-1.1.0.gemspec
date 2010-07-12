# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{Saikuro}
  s.version = "1.1.0"

  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.authors = ["Zev Blut"]
  s.cert_chain = nil
  s.date = %q{2008-06-20}
  s.default_executable = %q{saikuro}
  s.email = %q{zb@ubit.com}
  s.executables = ["saikuro"]
  s.extra_rdoc_files = ["README"]
  s.files = ["bin/saikuro", "lib/saikuro", "lib/saikuro/usage.rb", "lib/saikuro.rb", "tests/large_example.rb", "tests/samples.rb", "README"]
  s.homepage = %q{http://saikuro.rubyforge.org/}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("> 0.0.0")
  s.rubyforge_project = %q{saikuro}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Saikuro is a Ruby cyclomatic complexity analyzer.  When given Ruby source code Saikuro will generate a report listing the cyclomatic complexity of each method found.  In addition, Saikuro counts the number of lines per method and can generate a listing of the number of tokens on each line of code.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 1

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
