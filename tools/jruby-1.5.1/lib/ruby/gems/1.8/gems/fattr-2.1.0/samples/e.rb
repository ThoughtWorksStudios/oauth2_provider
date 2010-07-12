#
# my favourite element of fattrs is that getters can also be setters.
# this allows incredibly clean looking code like
#
  require 'fattr'

  class Config
    fattrs %w( host port)
    def initialize(&block) instance_eval &block end
  end

  conf = Config.new{
    host 'codeforpeople.org'
    port 80
  }

  p conf
