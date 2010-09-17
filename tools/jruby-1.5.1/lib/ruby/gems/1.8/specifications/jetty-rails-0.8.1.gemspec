# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{jetty-rails}
  s.version = "0.8.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Fabio Kung"]
  s.date = %q{2009-07-07}
  s.description = %q{Jetty Rails aims to run Ruby on Rails and Merb applications with the Jetty Container, leveraging the power of JRuby and jruby-rack.

{Jetty}[http://jetty.mortbay.com/jetty/] is an excellent Java Web Server, being and at the same time extremely lightweight. This makes jetty-rails a good alternative for JRuby on Rails or Merb development and deployment.

The project has born from my own needs ({read more}[http://fabiokung.com/2008/05/14/jetty-rails-gem-simple-jruby-on-rails-development-with-servlet-containers/]). I needed to run {JForum}[http://jforum.net] in the same context of my JRuby on Rails application. I had also to integrate HttpSessions (avoiding single sign on) and use ServletContext in-memory cache store.}
  s.email = ["fabio.kung@gmail.com"]
  s.executables = ["jetty_merb", "jetty_rails"]
  s.extra_rdoc_files = ["History.txt", "Licenses.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "TODO.txt", "website/index.txt"]
  s.files = ["History.txt", "Licenses.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "TODO.txt", "bin/jetty_merb", "bin/jetty_rails", "jetty-libs/core-3.1.1.jar", "jetty-libs/jetty-6.1.14.jar", "jetty-libs/jetty-plus-6.1.14.jar", "jetty-libs/jetty-util-6.1.14.jar", "jetty-libs/jsp-2.1.jar", "jetty-libs/jsp-api-2.1.jar", "jetty-libs/servlet-api-2.5-6.1.14.jar", "lib/jetty_rails.rb", "lib/jetty_rails/adapters/abstract_adapter.rb", "lib/jetty_rails/adapters/merb_adapter.rb", "lib/jetty_rails/adapters/rails_adapter.rb", "lib/jetty_rails/config/command_line_reader.rb", "lib/jetty_rails/config/rdoc_fix.rb", "lib/jetty_rails/handler/delegate_on_errors_handler.rb", "lib/jetty_rails/handler/public_directory_handler.rb", "lib/jetty_rails/handler/web_app_handler.rb", "lib/jetty_rails/jars.rb", "lib/jetty_rails/runner.rb", "lib/jetty_rails/server.rb", "lib/jetty_rails/warbler_reader.rb", "lib/jruby-rack-0.9.5-SNAPSHOT.jar", "script/console", "script/destroy", "script/generate", "script/txt2html", "spec/config.yml", "spec/jetty_merb_spec.rb", "spec/jetty_rails/config_file_spec.rb", "spec/jetty_rails/handler/delegate_on_errors_handler_spec.rb", "spec/jetty_rails/runner_spec.rb", "spec/jetty_rails_sample_1.yml", "spec/jetty_rails_sample_2.yml", "spec/jetty_rails_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "tasks/jruby.rake", "tasks/rspec.rake", "website/index.txt", "website/javascripts/rounded_corners_lite.inc.js", "website/stylesheets/screen.css", "website/template.html.erb"]
  s.homepage = %q{http://jetty-rails.rubyforge.net}
  s.post_install_message = %q{PostInstall.txt}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{jetty-rails}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Jetty Rails aims to run Ruby on Rails and Merb applications with the Jetty Container, leveraging the power of JRuby and jruby-rack}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 2.0.2"])
      s.add_development_dependency(%q<newgem>, [">= 1.4.1"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<activesupport>, [">= 2.0.2"])
      s.add_dependency(%q<newgem>, [">= 1.4.1"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 2.0.2"])
    s.add_dependency(%q<newgem>, [">= 1.4.1"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
