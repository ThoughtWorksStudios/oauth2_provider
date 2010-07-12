# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{metric_fu}
  s.version = "1.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jake Scruggs", "Sean Soper", "Andre Arko", "Petrik de Heus", "Grant McInnes", "Nick Quaranto", "\303\211douard Bri\303\250re", "Carl Youngblood", "Richard Huang", "Dan Mayer"]
  s.date = %q{2010-06-18}
  s.description = %q{Code metrics from Flog, Flay, RCov, Saikuro, Churn, Reek, Roodi, Rails' stats task and Rails Best Practices}
  s.email = %q{jake.scruggs@gmail.com}
  s.files = ["README", "HISTORY", "TODO", "MIT-LICENSE", "Rakefile", "lib/base/base_template.rb", "lib/base/configuration.rb", "lib/base/generator.rb", "lib/base/graph.rb", "lib/base/md5_tracker.rb", "lib/base/report.rb", "lib/generators/churn.rb", "lib/generators/flay.rb", "lib/generators/flog.rb", "lib/generators/rails_best_practices.rb", "lib/generators/rcov.rb", "lib/generators/reek.rb", "lib/generators/roodi.rb", "lib/generators/saikuro.rb", "lib/generators/stats.rb", "lib/graphs/engines/bluff.rb", "lib/graphs/engines/gchart.rb", "lib/graphs/flay_grapher.rb", "lib/graphs/flog_grapher.rb", "lib/graphs/grapher.rb", "lib/graphs/rails_best_practices_grapher.rb", "lib/graphs/rcov_grapher.rb", "lib/graphs/reek_grapher.rb", "lib/graphs/roodi_grapher.rb", "lib/graphs/stats_grapher.rb", "lib/metric_fu.rb", "lib/templates/awesome/awesome_template.rb", "lib/templates/awesome/churn.html.erb", "lib/templates/awesome/css/buttons.css", "lib/templates/awesome/css/default.css", "lib/templates/awesome/css/integrity.css", "lib/templates/awesome/css/reset.css", "lib/templates/awesome/flay.html.erb", "lib/templates/awesome/flog.html.erb", "lib/templates/awesome/index.html.erb", "lib/templates/awesome/layout.html.erb", "lib/templates/awesome/rails_best_practices.html.erb", "lib/templates/awesome/rcov.html.erb", "lib/templates/awesome/reek.html.erb", "lib/templates/awesome/roodi.html.erb", "lib/templates/awesome/saikuro.html.erb", "lib/templates/awesome/stats.html.erb", "lib/templates/javascripts/bluff-min.js", "lib/templates/javascripts/excanvas.js", "lib/templates/javascripts/js-class.js", "lib/templates/standard/churn.html.erb", "lib/templates/standard/default.css", "lib/templates/standard/flay.html.erb", "lib/templates/standard/flog.html.erb", "lib/templates/standard/index.html.erb", "lib/templates/standard/rails_best_practices.html.erb", "lib/templates/standard/rcov.html.erb", "lib/templates/standard/reek.html.erb", "lib/templates/standard/roodi.html.erb", "lib/templates/standard/saikuro.html.erb", "lib/templates/standard/standard_template.rb", "lib/templates/standard/stats.html.erb", "tasks/metric_fu.rake", "spec/base/base_template_spec.rb", "spec/base/configuration_spec.rb", "spec/base/generator_spec.rb", "spec/base/graph_spec.rb", "spec/base/md5_tracker_spec.rb", "spec/base/report_spec.rb", "spec/generators/churn_spec.rb", "spec/generators/flay_spec.rb", "spec/generators/flog_spec.rb", "spec/generators/reek_spec.rb", "spec/generators/saikuro_spec.rb", "spec/generators/stats_spec.rb", "spec/graphs/engines/bluff_spec.rb", "spec/graphs/engines/gchart_spec.rb", "spec/graphs/flay_grapher_spec.rb", "spec/graphs/flog_grapher_spec.rb", "spec/graphs/rcov_grapher_spec.rb", "spec/graphs/reek_grapher_spec.rb", "spec/graphs/roodi_grapher_spec.rb", "spec/resources/saikuro/app/controllers/sessions_controller.rb_cyclo.html", "spec/resources/saikuro/app/controllers/users_controller.rb_cyclo.html", "spec/resources/saikuro/index_cyclo.html", "spec/resources/saikuro_sfiles/thing.rb_cyclo.html", "spec/resources/yml/20090630.yml", "spec/spec.opts", "spec/spec_helper.rb"]
  s.homepage = %q{http://metric-fu.rubyforge.org/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{A fistful of code metrics, with awesome templates and graphs}
  s.test_files = ["spec/base/base_template_spec.rb", "spec/base/configuration_spec.rb", "spec/base/generator_spec.rb", "spec/base/graph_spec.rb", "spec/base/md5_tracker_spec.rb", "spec/base/report_spec.rb", "spec/generators/churn_spec.rb", "spec/generators/flay_spec.rb", "spec/generators/flog_spec.rb", "spec/generators/reek_spec.rb", "spec/generators/saikuro_spec.rb", "spec/generators/stats_spec.rb", "spec/graphs/engines/bluff_spec.rb", "spec/graphs/engines/gchart_spec.rb", "spec/graphs/flay_grapher_spec.rb", "spec/graphs/flog_grapher_spec.rb", "spec/graphs/rcov_grapher_spec.rb", "spec/graphs/reek_grapher_spec.rb", "spec/graphs/roodi_grapher_spec.rb", "spec/resources/saikuro/app/controllers/sessions_controller.rb_cyclo.html", "spec/resources/saikuro/app/controllers/users_controller.rb_cyclo.html", "spec/resources/saikuro/index_cyclo.html", "spec/resources/saikuro_sfiles/thing.rb_cyclo.html", "spec/resources/yml/20090630.yml", "spec/spec.opts", "spec/spec_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<flay>, [">= 1.2.1"])
      s.add_runtime_dependency(%q<flog>, [">= 2.2.0"])
      s.add_runtime_dependency(%q<rcov>, [">= 0.8.3.3"])
      s.add_runtime_dependency(%q<reek>, [">= 1.2.6"])
      s.add_runtime_dependency(%q<roodi>, [">= 2.1.0"])
      s.add_runtime_dependency(%q<rails_best_practices>, [">= 0.3.16"])
      s.add_runtime_dependency(%q<chronic>, [">= 0.2.3"])
      s.add_runtime_dependency(%q<churn>, [">= 0.0.7"])
      s.add_runtime_dependency(%q<Saikuro>, [">= 1.1.0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 2.0.0"])
      s.add_development_dependency(%q<rspec>, [">= 1.2.0"])
      s.add_development_dependency(%q<test-construct>, [">= 1.2.0"])
      s.add_development_dependency(%q<googlecharts>, [">= 0"])
    else
      s.add_dependency(%q<flay>, [">= 1.2.1"])
      s.add_dependency(%q<flog>, [">= 2.2.0"])
      s.add_dependency(%q<rcov>, [">= 0.8.3.3"])
      s.add_dependency(%q<reek>, [">= 1.2.6"])
      s.add_dependency(%q<roodi>, [">= 2.1.0"])
      s.add_dependency(%q<rails_best_practices>, [">= 0.3.16"])
      s.add_dependency(%q<chronic>, [">= 0.2.3"])
      s.add_dependency(%q<churn>, [">= 0.0.7"])
      s.add_dependency(%q<Saikuro>, [">= 1.1.0"])
      s.add_dependency(%q<activesupport>, [">= 2.0.0"])
      s.add_dependency(%q<rspec>, [">= 1.2.0"])
      s.add_dependency(%q<test-construct>, [">= 1.2.0"])
      s.add_dependency(%q<googlecharts>, [">= 0"])
    end
  else
    s.add_dependency(%q<flay>, [">= 1.2.1"])
    s.add_dependency(%q<flog>, [">= 2.2.0"])
    s.add_dependency(%q<rcov>, [">= 0.8.3.3"])
    s.add_dependency(%q<reek>, [">= 1.2.6"])
    s.add_dependency(%q<roodi>, [">= 2.1.0"])
    s.add_dependency(%q<rails_best_practices>, [">= 0.3.16"])
    s.add_dependency(%q<chronic>, [">= 0.2.3"])
    s.add_dependency(%q<churn>, [">= 0.0.7"])
    s.add_dependency(%q<Saikuro>, [">= 1.1.0"])
    s.add_dependency(%q<activesupport>, [">= 2.0.0"])
    s.add_dependency(%q<rspec>, [">= 1.2.0"])
    s.add_dependency(%q<test-construct>, [">= 1.2.0"])
    s.add_dependency(%q<googlecharts>, [">= 0"])
  end
end
