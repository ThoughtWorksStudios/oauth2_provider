require File.dirname(__FILE__) + '/spec_helper.rb'

describe "binary executable with no command line arguments" do
  
  it "should set adapter to merb" do
    runner = mock("runner", :null_object => true)
    current_dir = Dir.pwd
    JettyRails::Runner.should_receive(:new) do |config|
      config.should have_key(:adapter)
      config[:adapter].should == :merb
      runner
    end
    load File.dirname(__FILE__) + '/../bin/jetty_merb'      
  end
  
  it "should provide the current execution dir as basedir" do
    runner = mock("runner", :null_object => true)
    current_dir = Dir.pwd
    JettyRails::Runner.should_receive(:new) do |config|
      config.should have_key(:base)
      config[:base].should == current_dir
      runner
    end
    load File.dirname(__FILE__) + '/../bin/jetty_merb'
  end
  
  it "should not set the context path by default" do
    runner = mock("runner", :null_object => true)
    JettyRails::Runner.should_receive(:new) do |config|
      config.should_not have_key(:context_path)
      runner
    end
    load File.dirname(__FILE__) + '/../bin/jetty_merb'
  end
  
  it "should not set the environment by default" do
    runner = mock("runner", :null_object => true)
    JettyRails::Runner.should_receive(:new) do |config|
      config.should_not have_key(:environment)
      runner
    end
    load File.dirname(__FILE__) + '/../bin/jetty_merb'
  end
  
  it "should set the port to 4000 by default" do
    runner = mock("runner", :null_object => true)
    JettyRails::Runner.should_receive(:new) do |config|
      config.should have_key(:port)
      config[:port].should == 4000
      runner
    end
    load File.dirname(__FILE__) + '/../bin/jetty_merb'
  end
  
  it "should not set classes dir by default" do
    runner = mock("runner", :null_object => true)
    JettyRails::Runner.should_receive(:new) do |config|
      config.should_not have_key(:classes_dir)
      runner
    end
    load File.dirname(__FILE__) + '/../bin/jetty_merb'
  end
  
  it "should not set lib dir by default" do
    runner = mock("runner", :null_object => true)
    JettyRails::Runner.should_receive(:new) do |config|
      config.should_not have_key(:lib_dir)
      runner
    end
    load File.dirname(__FILE__) + '/../bin/jetty_merb'
  end
end

describe "binary executable with command line arguments" do
  
  it "should take the first command line argument as basedir" do
    ARGV[0] = '/any/app/dir'
    runner = mock("runner", :null_object => true)
    JettyRails::Runner.should_receive(:new) do |config|
      config.should have_key(:base)
      config[:base].should == '/any/app/dir'
      runner
    end
    load File.dirname(__FILE__) + '/../bin/jetty_merb'
  end
  
  it "should take --context-path command line option as context path" do
    ARGV[0] = '--context-path'
    ARGV[1] = '/myapp'
    runner = mock("runner", :null_object => true)
    JettyRails::Runner.should_receive(:new) do |config|
      config.should have_key(:context_path)
      config[:context_path].should == '/myapp'
      runner
    end
    load File.dirname(__FILE__) + '/../bin/jetty_merb'
  end
  
  it "should take -u command line option as context path" do
    ARGV[0] = '-u'
    ARGV[1] = '/myapp'
    runner = mock("runner", :null_object => true)
    JettyRails::Runner.should_receive(:new) do |config|
      config.should have_key(:context_path)
      config[:context_path].should == '/myapp'
      runner
    end
    load File.dirname(__FILE__) + '/../bin/jetty_merb'
  end
  
  it "should take --environment command line option as custom environment" do
    ARGV[0] = '--environment'
    ARGV[1] = 'production'
    runner = mock("runner", :null_object => true)
    JettyRails::Runner.should_receive(:new) do |config|
      config.should have_key(:environment)
      config[:environment].should == 'production'
      runner
    end
    load File.dirname(__FILE__) + '/../bin/jetty_merb'
  end
  
  it "should take -e command line option as custom environment" do
    ARGV[0] = '-e'
    ARGV[1] = 'production'
    runner = mock("runner", :null_object => true)
    JettyRails::Runner.should_receive(:new) do |config|
      config.should have_key(:environment)
      config[:environment].should == 'production'
      runner
    end
    load File.dirname(__FILE__) + '/../bin/jetty_merb'
  end
  
  it "should take --port command line option as custom server port" do
    ARGV[0] = '--port'
    ARGV[1] = '80'
    runner = mock("runner", :null_object => true)
    JettyRails::Runner.should_receive(:new) do |config|
      config.should have_key(:port)
      config[:port].should == 80
      runner
    end
    load File.dirname(__FILE__) + '/../bin/jetty_merb'
  end
  
  it "should take -p command line option as custom server port" do
    ARGV[0] = '-p'
    ARGV[1] = '80'
    runner = mock("runner", :null_object => true)
    JettyRails::Runner.should_receive(:new) do |config|
      config.should have_key(:port)
      config[:port].should == 80
      runner
    end
    load File.dirname(__FILE__) + '/../bin/jetty_merb'
  end
  
  it "should take --classes command line option as custom classes dir" do
    ARGV[0] = '--classes'
    ARGV[1] = 'build/java/classes'
    runner = mock("runner", :null_object => true)
    JettyRails::Runner.should_receive(:new) do |config|
      config.should have_key(:classes_dir)
      config[:classes_dir].should == 'build/java/classes'
      runner
    end
    load File.dirname(__FILE__) + '/../bin/jetty_merb'
  end
  
  it "should take --lib command line option as custom jars dir" do
    ARGV[0] = '--lib'
    ARGV[1] = 'java/jars'
    runner = mock("runner", :null_object => true)
    JettyRails::Runner.should_receive(:new) do |config|
      config.should have_key(:lib_dir)
      config[:lib_dir].should == 'java/jars'
      runner
    end
    load File.dirname(__FILE__) + '/../bin/jetty_merb'
  end
    
  it "should take --jars command line option as custom jars dir" do
    ARGV[0] = '--jars'
    ARGV[1] = 'java/jars'
    runner = mock("runner", :null_object => true)
    JettyRails::Runner.should_receive(:new) do |config|
      config.should have_key(:lib_dir)
      config[:lib_dir].should == 'java/jars'
      runner
    end
    load File.dirname(__FILE__) + '/../bin/jetty_merb'
  end
  
end
