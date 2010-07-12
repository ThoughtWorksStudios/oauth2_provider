# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{churn}
  s.version = "0.0.12"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dan Mayer"]
  s.date = %q{2010-02-22}
  s.default_executable = %q{churn}
  s.description = %q{High method and class churn has been shown to have increased bug and error rates. This gem helps you know what is changing a lot so you can do additional testing, code review, or refactoring to try to tame the volatile code. }
  s.email = %q{dan@devver.net}
  s.executables = ["churn"]
  s.extra_rdoc_files = ["LICENSE", "README.rdoc"]
  s.files = [".document", ".gitignore", "LICENSE", "README.rdoc", "Rakefile", "VERSION", "bin/churn", "lib/churn.rb", "lib/churn/churn_calculator.rb", "lib/churn/churn_history.rb", "lib/churn/git_analyzer.rb", "lib/churn/hg_analyzer.rb", "lib/churn/location_mapping.rb", "lib/churn/source_control.rb", "lib/churn/svn_analyzer.rb", "lib/tasks/churn_tasks.rb", "test/data/churn_calculator.rb", "test/data/test_helper.rb", "test/test_helper.rb", "test/unit/churn_calculator_test.rb", "test/unit/churn_history_test.rb", "test/unit/git_analyzer_test.rb", "test/unit/hg_analyzer_test.rb", "test/unit/location_mapping_test.rb"]
  s.homepage = %q{http://github.com/danmayer/churn}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Providing additional churn metrics over the original metric_fu churn}
  s.test_files = ["test/data/churn_calculator.rb", "test/data/test_helper.rb", "test/test_helper.rb", "test/unit/churn_calculator_test.rb", "test/unit/churn_history_test.rb", "test/unit/git_analyzer_test.rb", "test/unit/hg_analyzer_test.rb", "test/unit/location_mapping_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_development_dependency(%q<test-construct>, [">= 0"])
      s.add_development_dependency(%q<mocha>, ["~> 0.9.5"])
      s.add_runtime_dependency(%q<main>, [">= 0"])
      s.add_runtime_dependency(%q<json_pure>, [">= 0"])
      s.add_runtime_dependency(%q<chronic>, ["~> 0.2.3"])
      s.add_runtime_dependency(%q<sexp_processor>, ["~> 3.0.3"])
      s.add_runtime_dependency(%q<ruby_parser>, ["~> 2.0.4"])
      s.add_runtime_dependency(%q<hirb>, [">= 0"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_dependency(%q<test-construct>, [">= 0"])
      s.add_dependency(%q<mocha>, ["~> 0.9.5"])
      s.add_dependency(%q<main>, [">= 0"])
      s.add_dependency(%q<json_pure>, [">= 0"])
      s.add_dependency(%q<chronic>, ["~> 0.2.3"])
      s.add_dependency(%q<sexp_processor>, ["~> 3.0.3"])
      s.add_dependency(%q<ruby_parser>, ["~> 2.0.4"])
      s.add_dependency(%q<hirb>, [">= 0"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    s.add_dependency(%q<test-construct>, [">= 0"])
    s.add_dependency(%q<mocha>, ["~> 0.9.5"])
    s.add_dependency(%q<main>, [">= 0"])
    s.add_dependency(%q<json_pure>, [">= 0"])
    s.add_dependency(%q<chronic>, ["~> 0.2.3"])
    s.add_dependency(%q<sexp_processor>, ["~> 3.0.3"])
    s.add_dependency(%q<ruby_parser>, ["~> 2.0.4"])
    s.add_dependency(%q<hirb>, [">= 0"])
  end
end
