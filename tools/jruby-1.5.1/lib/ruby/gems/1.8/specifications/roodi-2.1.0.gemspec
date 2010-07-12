# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{roodi}
  s.version = "2.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Marty Andrews"]
  s.date = %q{2009-12-27}
  s.description = %q{Roodi stands for Ruby Object Oriented Design Inferometer.  It parses your Ruby code and warns you about design issues you have based on the checks that is has configured.}
  s.email = ["marty@cogentconsulting.com.au"]
  s.executables = ["roodi", "roodi-describe"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "bin/roodi", "bin/roodi-describe", "lib/roodi.rb", "lib/roodi/checks.rb", "lib/roodi/checks/abc_metric_method_check.rb", "lib/roodi/checks/assignment_in_conditional_check.rb", "lib/roodi/checks/case_missing_else_check.rb", "lib/roodi/checks/check.rb", "lib/roodi/checks/class_line_count_check.rb", "lib/roodi/checks/class_name_check.rb", "lib/roodi/checks/class_variable_check.rb", "lib/roodi/checks/control_coupling_check.rb", "lib/roodi/checks/cyclomatic_complexity_block_check.rb", "lib/roodi/checks/cyclomatic_complexity_check.rb", "lib/roodi/checks/cyclomatic_complexity_method_check.rb", "lib/roodi/checks/empty_rescue_body_check.rb", "lib/roodi/checks/for_loop_check.rb", "lib/roodi/checks/line_count_check.rb", "lib/roodi/checks/method_line_count_check.rb", "lib/roodi/checks/method_name_check.rb", "lib/roodi/checks/missing_foreign_key_index_check.rb", "lib/roodi/checks/module_line_count_check.rb", "lib/roodi/checks/module_name_check.rb", "lib/roodi/checks/name_check.rb", "lib/roodi/checks/npath_complexity_check.rb", "lib/roodi/checks/npath_complexity_method_check.rb", "lib/roodi/checks/parameter_number_check.rb", "lib/roodi/core.rb", "lib/roodi/core/checking_visitor.rb", "lib/roodi/core/error.rb", "lib/roodi/core/parser.rb", "lib/roodi/core/runner.rb", "lib/roodi/core/visitable_sexp.rb", "lib/roodi_task.rb", "roodi.yml", "spec/roodi/checks/abc_metric_method_check_spec.rb", "spec/roodi/checks/assignment_in_conditional_check_spec.rb", "spec/roodi/checks/case_missing_else_check_spec.rb", "spec/roodi/checks/class_line_count_check_spec.rb", "spec/roodi/checks/class_name_check_spec.rb", "spec/roodi/checks/class_variable_check_spec.rb", "spec/roodi/checks/control_coupling_check_spec.rb", "spec/roodi/checks/cyclomatic_complexity_block_check_spec.rb", "spec/roodi/checks/cyclomatic_complexity_method_check_spec.rb", "spec/roodi/checks/empty_rescue_body_check_spec.rb", "spec/roodi/checks/for_loop_check_spec.rb", "spec/roodi/checks/method_line_count_check_spec.rb", "spec/roodi/checks/method_name_check_spec.rb", "spec/roodi/checks/missing_foreign_key_index_check_spec.rb", "spec/roodi/checks/module_line_count_check_spec.rb", "spec/roodi/checks/module_name_check_spec.rb", "spec/roodi/checks/npath_complexity_method_check_spec.rb", "spec/roodi/checks/parameter_number_check_spec.rb", "spec/roodi/core/runner_spec.rb", "spec/roodi/roodi.yml", "spec/spec_helper.rb"]
  s.homepage = %q{http://roodi.rubyforge.org}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{roodi}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Roodi stands for Ruby Object Oriented Design Inferometer}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ruby_parser>, [">= 0"])
      s.add_development_dependency(%q<hoe>, [">= 2.3.3"])
    else
      s.add_dependency(%q<ruby_parser>, [">= 0"])
      s.add_dependency(%q<hoe>, [">= 2.3.3"])
    end
  else
    s.add_dependency(%q<ruby_parser>, [">= 0"])
    s.add_dependency(%q<hoe>, [">= 2.3.3"])
  end
end
