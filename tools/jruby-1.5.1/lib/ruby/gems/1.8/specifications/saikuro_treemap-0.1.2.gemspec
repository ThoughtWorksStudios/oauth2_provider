# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{saikuro_treemap}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["ThoughtWorks Studios"]
  s.date = %q{2010-07-17}
  s.description = %q{Generate CCN Treemap based on saikuro analysis}
  s.email = %q{studios@thoughtworks.com}
  s.extra_rdoc_files = ["README.textile"]
  s.files = [".gitignore", "MIT-LICENSE.txt", "README.textile", "Rakefile", "lib/saikuro_treemap.rb", "lib/saikuro_treemap/ccn_node.rb", "lib/saikuro_treemap/parser.rb", "lib/saikuro_treemap/version.rb", "templates/css/treemap.css", "templates/images/tw_open_source_small.png", "templates/js/jit-min.js", "templates/js/jit.js", "templates/js/saikuro-render.js", "templates/saikuro.html.erb", "test/ccn_node_test.rb", "test/test_helper.rb", "saikuro_treemap.gemspec"]
  s.homepage = %q{http://github.com/ThoughtWorksStudios/saikuro_treemap}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Generate CCN Treemap based on saikuro analysis}
  s.test_files = ["test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json_pure>, [">= 0"])
      s.add_runtime_dependency(%q<Saikuro>, [">= 0"])
    else
      s.add_dependency(%q<json_pure>, [">= 0"])
      s.add_dependency(%q<Saikuro>, [">= 0"])
    end
  else
    s.add_dependency(%q<json_pure>, [">= 0"])
    s.add_dependency(%q<Saikuro>, [">= 0"])
  end
end
