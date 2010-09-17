class WarblerReader
  
  def initialize(config)
    # TODO ignore jruby and jruby-rack
    warbler_config = load("#{config[:base]}/config/warble.rb")
    warbler_config.java_libs.each do |jar|
      require jar
    end
    # TODO require custom classes
  end
  
  
end