require 'getoptlong'
require 'jetty_rails/config/rdoc_fix'


class CommandLineReader

  def default_config()
    @@config ||= {
      :rails => { 
        :base => Dir.pwd,
        :port => 3000,
        :ssl_port => 3443,
        :config_file => "#{File.join(Dir.pwd, 'config', 'jetty_rails.yml')}",
        :adapter => :rails
      },
      :merb => {
        :base => Dir.pwd,
        :port => 4000,
        :config_file => "#{File.join(Dir.pwd, 'config', 'jetty_merb.yml')}",
        :adapter => :merb
      }
    }
  end

  def read(default_adapter = :rails)
    config = default_config[default_adapter]
    
    opts = GetoptLong.new(
      [ '--version', '-v', GetoptLong::NO_ARGUMENT ],
      [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
      [ '--context-path', '-u', GetoptLong::REQUIRED_ARGUMENT ],
      [ '--port', '-p', GetoptLong::REQUIRED_ARGUMENT ],
      [ '--ssl-port', '-s', GetoptLong::REQUIRED_ARGUMENT ],
      [ '--environment', '-e', GetoptLong::REQUIRED_ARGUMENT ],
      [ '--lib', '--jars', GetoptLong::REQUIRED_ARGUMENT ],
      [ '--classes', GetoptLong::REQUIRED_ARGUMENT ],
      [ '--config', '-c', GetoptLong::OPTIONAL_ARGUMENT ]
    )
    
    opts.each do |opt, arg|
      case opt
        when '--version'
          require 'jetty_rails/version'
          puts "JettyRails version #{JettyRails::VERSION::STRING} - http://jetty-rails.rubyforge.org"
          exit(0)
        when '--help'
          RDoc::usage
        when '--context-path'
          config[:context_path] = arg
        when '--port'
          config[:port] = arg.to_i
        when '--ssl-port'
          config[:ssl_port] = arg.to_i
        when '--environment'
          config[:environment] = arg
        when '--classes'
          config[:classes_dir] = arg
        when '--lib'
          config[:lib_dir] = arg
    	  when '--config'
    	    config[:config_file] = arg if !arg.nil? && arg != ""
    	    config.merge!(YAML.load_file(config[:config_file]))
      end
    end

    config[:base] = ARGV.shift unless ARGV.empty?
    config
  end  
  
end


