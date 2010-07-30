# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

require 'oauth2/provider/a_r_datasource'
require 'oauth2/provider/ruby_in_memory_datasource'
require 'oauth2/provider/model_base'

Oauth2::Provider::ModelBase.datasource = ENV["OAUTH2_PROVIDER_DATASOURCE"] || Oauth2::Provider::ARDatasource
