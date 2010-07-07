ENV['CI_REPORTS'] = "#{RAILS_ROOT}/reports" # put reports in a different dir

require 'rubygems'
gem 'ci_reporter'
# require 'ci/reporter/rake/rspec'     # use this if you're using RSpec
# require 'ci/reporter/rake/cucumber'  # use this if you're using Cucumber
require 'ci/reporter/rake/test_unit' # use this if you're using Test::Unit

# add to dependencies
Rake::Task['test'].prerequisites ||= []
Rake::Task['test'].prerequisites << 'ci:setup:testunit'
