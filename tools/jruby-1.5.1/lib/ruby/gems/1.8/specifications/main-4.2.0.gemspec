# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{main}
  s.version = "4.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ara T. Howard"]
  s.date = %q{2009-11-01}
  s.description = %q{a class factory and dsl for generating command line programs real quick}
  s.email = %q{ara.t.howard@gmail.com}
  s.files = ["a.rb", "lib/main/cast.rb", "lib/main/dsl.rb", "lib/main/factories.rb", "lib/main/getoptlong.rb", "lib/main/logger.rb", "lib/main/mode.rb", "lib/main/parameter.rb", "lib/main/program/class_methods.rb", "lib/main/program/instance_methods.rb", "lib/main/program.rb", "lib/main/softspoken.rb", "lib/main/stdext.rb", "lib/main/test.rb", "lib/main/usage.rb", "lib/main/util.rb", "lib/main.rb", "main.gemspec", "Rakefile", "README", "README.erb", "samples/a.rb", "samples/b.rb", "samples/c.rb", "samples/d.rb", "samples/e.rb", "samples/f.rb", "samples/g.rb", "samples/h.rb", "samples/j.rb", "test/main.rb", "TODO"]
  s.homepage = %q{http://github.com/ahoward/main/tree/master}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{codeforpeople}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{main}
  s.test_files = ["test/main.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<fattr>, [">= 2.1.0"])
      s.add_runtime_dependency(%q<arrayfields>, [">= 4.7.4"])
    else
      s.add_dependency(%q<fattr>, [">= 2.1.0"])
      s.add_dependency(%q<arrayfields>, [">= 4.7.4"])
    end
  else
    s.add_dependency(%q<fattr>, [">= 2.1.0"])
    s.add_dependency(%q<arrayfields>, [">= 4.7.4"])
  end
end
