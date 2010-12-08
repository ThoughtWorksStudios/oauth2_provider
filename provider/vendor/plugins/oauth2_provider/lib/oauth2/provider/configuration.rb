# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

module Oauth2
  module Provider
    module Configuration
      def self.def_properties(*names)
        names.each do |name|
          class_eval(<<-EOS, __FILE__, __LINE__)
            @@__#{name} = nil
            def #{name}
              @@__#{name}.respond_to?(:call) ? @@__#{name}.call : @@__#{name}
            end
            
            def #{name}=(value_or_proc)
              @@__#{name} = value_or_proc
            end
            module_function :#{name}, :#{name}=
          EOS

          self.send(:module_function, name, "#{name}=")
        end
      end

      def_properties :ssl_port, :ssl_enabled
    end

  end
end
