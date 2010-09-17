require File.dirname(__FILE__) + '/../spec_helper'

describe JettyRails::Runner, "with no extra configuration (rails adapter)" do
  it "should require basedir to be run" do
    lambda { JettyRails::Runner.new }.should raise_error 
  end
  
  it "should receive basedir configuration" do
    runner = JettyRails::Runner.new :base => '/any/app/dir'
    runner.servers[8080].config.should have_key(:base)
    runner.servers[8080].config[:base].should == '/any/app/dir'
  end
  
  it "should default to development environment" do
    runner = JettyRails::Runner.new :base => Dir.pwd
    runner.servers[8080].config.should have_key(:environment)
    runner.servers[8080].config[:environment].should == 'development'
    runner.servers[8080].app_contexts.first.init_params['rails.env'].should == 'development'
  end
  
  it "should default to the root context path" do
    runner = JettyRails::Runner.new :base => Dir.pwd
    runner.servers[8080].config.should have_key(:context_path)
    runner.servers[8080].config[:context_path].should == '/'
    runner.servers[8080].app_contexts.first.context_path.should == '/'
  end
  
  it "should set server default port to 8080" do
    runner = JettyRails::Runner.new :base => Dir.pwd
    runner.servers[8080].config.should have_key(:port)
    runner.servers[8080].config[:port].should == 8080
  end
  
  it "should default lib_dir to lib" do
    runner = JettyRails::Runner.new :base => Dir.pwd
    runner.servers[8080].config.should have_key(:lib_dir)
    runner.servers[8080].config[:lib_dir].should == 'lib'
  end
  
  it "should set rails root" do
    runner = JettyRails::Runner.new :base => Dir.pwd
    runner.servers[8080].app_contexts.first.init_params['rails.root'].should == '/'
  end
  
  it "should set public root" do
    runner = JettyRails::Runner.new :base => Dir.pwd
    runner.servers[8080].app_contexts.first.init_params['public.root'].should == '/public'
  end
  
  it "should set gem path" do
    original = ENV['GEM_PATH']
    ENV['GEM_PATH'] = nil
    begin
      runner = JettyRails::Runner.new :base => Dir.pwd
      runner.servers[8080].app_contexts.first.init_params['gem.path'].should == 'tmp/war/WEB-INF/gems'
    ensure
      ENV['GEM_PATH'] = original
    end
  end
  
  it "should set gem path from environment" do
    original = ENV['GEM_PATH']
    ENV['GEM_PATH'] = "/usr/lib/ruby/gems/1.8/gems"
    begin
      runner = JettyRails::Runner.new :base => Dir.pwd
      runner.servers[8080].app_contexts.first.init_params['gem.path'].should == ENV['GEM_PATH']
    ensure
      ENV['GEM_PATH'] = original
    end
  end
  
  
  it "should install RailsServletContextListener" do
    runner = JettyRails::Runner.new :base => Dir.pwd
    listeners = runner.servers[8080].app_contexts.first.event_listeners
    listeners.size.should == 1
    listeners[0].should be_kind_of(JettyRails::Rack::RailsServletContextListener)
  end
    
  it "should have handlers for static and dynamic content" do
    runner = JettyRails::Runner.new :base => Dir.pwd
    runner.servers[8080].server.handlers.size.should == 2
    resource_handlers = runner.servers[8080].server.getChildHandlersByClass(JettyRails::Jetty::Handler::ResourceHandler)
    resource_handlers.size.should == 1
    webapp_handlers = runner.servers[8080].server.getChildHandlersByClass(JettyRails::Jetty::Handler::WebAppContext)
    webapp_handlers.size.should == 1
  end
  
  it "should delegate to rails handler if requested dir has no welcome file" do
    runner = JettyRails::Runner.new :base => Dir.pwd
    delegate_handler = runner.servers[8080].server.handlers[0]
    delegate_handler.should be_kind_of(JettyRails::Handler::DelegateOnErrorsHandler)
  end
  
end

describe JettyRails::Runner, "with custom configuration" do
  
  it "should allow to override the environment" do
    runner = JettyRails::Runner.new :base => Dir.pwd, :environment => 'production'
    runner.servers[8080].config.should have_key(:environment)
    runner.servers[8080].config[:environment].should == 'production'
    runner.servers[8080].app_contexts.first.init_params['rails.env'].should == 'production'
  end
  
  it "should allow to override the context path" do
    runner = JettyRails::Runner.new :base => Dir.pwd, :context_path => "/myapp" 
    runner.servers[8080].config.should have_key(:context_path)
    runner.servers[8080].config[:context_path].should == '/myapp'
    runner.servers[8080].app_contexts.first.context_path.should == '/myapp'
  end
  
  it "should allow to override the server port" do
    runner = JettyRails::Runner.new :base => Dir.pwd, :port => 8585 
    runner.servers[8585].config.should have_key(:port)
    runner.servers[8585].config[:port].should == 8585
    runner.servers[8585].server.connectors[0].port.should == 8585
  end
  
  it "should handle custom context paths for static and dynamic content" do
    runner = JettyRails::Runner.new :base => Dir.pwd, :context_path => "/myapp" 
    context_handlers = runner.servers[8080].server.getChildHandlersByClass(JettyRails::Jetty::Handler::ContextHandler)
    context_handlers.size.should == 2 # one for static, one for dynamic
  end
end

describe JettyRails::Runner, "with merb adapter" do
  
  it "should set merb root" do
    runner = JettyRails::Runner.new :adapter => :merb, :base => Dir.pwd
    runner.servers[8080].app_contexts.first.init_params['merb.root'].should == '/'
  end
  
  it "should set public root" do
    runner = JettyRails::Runner.new :adapter => :merb, :base => Dir.pwd
    runner.servers[8080].app_contexts.first.init_params['public.root'].should == '/public'
  end
  
  it "should set gem path" do
    original = ENV['GEM_PATH']
    ENV['GEM_PATH'] = nil
    begin
      runner = JettyRails::Runner.new :adapter => :merb, :base => Dir.pwd
      runner.servers[8080].app_contexts.first.init_params['gem.path'].should == 'tmp/war/WEB-INF/gems'
    ensure
      ENV['GEM_PATH'] = original
    end
  end
  
  it "should set merb environment to development" do
    runner = JettyRails::Runner.new :adapter => :merb, :base => Dir.pwd
    runner.servers[8080].app_contexts.first.init_params['merb.environment'].should == 'development'
  end
  
  it "should install MerbServletContextListener and SignalHandler" do
    runner = JettyRails::Runner.new :adapter => :merb, :base => Dir.pwd
    listeners = runner.servers[8080].app_contexts.first.event_listeners
    listeners.size.should == 2
    listeners[0].should be_kind_of(JettyRails::Rack::MerbServletContextListener)
    listeners[1].should be_kind_of(JettyRails::Adapters::MerbAdapter::SignalHandler)
  end
end
