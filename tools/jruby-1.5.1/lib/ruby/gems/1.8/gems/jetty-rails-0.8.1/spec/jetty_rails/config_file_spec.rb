require File.dirname(__FILE__) + '/../spec_helper'

describe JettyRails::Runner, "with config file containing several servers and apps" do
  before do
    @yaml_config = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'config.yml'))
  end
  
  it "should instantiate runner with config.yml and setup servers" do
    runner = JettyRails::Runner.new(@yaml_config)
    runner.servers.size.should == 3
    runner.servers[4000].should_not == nil
    runner.servers[3000].should_not == nil
    server = runner.servers[8080]
    server.should_not == nil
    server.app_contexts.size.should == 2
  end
  
  it "should setup correct context_paths" do
    runner = JettyRails::Runner.new(@yaml_config)
    runner.servers[4000].config[:context_path].should == "/testB"
    runner.servers[3000].config[:context_path].should == "/testA"
    
    runner.servers[8080].config[:context_path].should == "/"
    runner.servers[8080].app_contexts[0].context_path.should == "/testC"
    runner.servers[8080].app_contexts[1].context_path.should == "/testD"
  end  
  
  it "should setup correct adapters" do
    runner = JettyRails::Runner.new(@yaml_config)
    runner.servers[4000].config[:adapter].should == :merb
    runner.servers[3000].config[:adapter].should == :rails
    
    runner.servers[8080].config[:adapter].should == :rails # default
    runner.servers[8080].app_contexts[0].config[:adapter].should == :merb
    runner.servers[8080].app_contexts[1].config[:adapter].should == :rails
  end  
  
  it "should inherit environment" do
    runner = JettyRails::Runner.new(@yaml_config)
    runner.servers[4000].config[:environment].should == "production"
    runner.servers[3000].config[:environment].should == "development"
    
    runner.servers[8080].config[:environment].should == "production"
    runner.servers[8080].app_contexts[0].config[:environment].should =="test"
    runner.servers[8080].app_contexts[1].config[:environment].should =="production"
  end

  it "should setup jruby environment" do
    runner = JettyRails::Runner.new(@yaml_config)
    runner.servers[4000].app_contexts.first.adapter.init_params['jruby.min.runtimes'].should == '1'
    runner.servers[4000].app_contexts.first.adapter.init_params['jruby.max.runtimes'].should == '2'

    runner.servers[3000].app_contexts.first.adapter.init_params['jruby.min.runtimes'].should == '2'
    runner.servers[3000].app_contexts.first.adapter.init_params['jruby.max.runtimes'].should == '2'    
  end
  
  it "should setup the server thread pool" do
    runner = JettyRails::Runner.new(@yaml_config)
    runner.servers[4000].server.thread_pool.max_threads.should == 40
    runner.servers[4000].server.thread_pool.min_threads.should == 1
  end

  it "should setup the server acceptors" do
    runner = JettyRails::Runner.new(@yaml_config)
    runner.servers[3000].server.connectors[0].acceptors.should == 20
  end
  
end
