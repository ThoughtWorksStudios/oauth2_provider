#
# of course fattrs works as well at class/module level as at instance
# level
#
  require 'fattr'

  module Logging 
    Level_names = {
      0 => 'INFO',
      # ...
      42 => 'DEBUG',
    }

    class << Logging
      fattr 'level' => 42
      fattr('level_name'){ Level_names[level] }
    end
  end

p Logging.level
p Logging.level_name
