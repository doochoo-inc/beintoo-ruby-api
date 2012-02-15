require 'rubygems'
require 'supermodel'
require 'beintoo'
require 'rspec'
require 'pry'

def set_testing_data
  Beintoo.configure do |config|
    config.apikey  = "1234567890"
    config.redirect_uri = "http://localhost:3000"
    config.sandbox = true
    config.debug   = true
  end
end

def set_real_case_data
  # Beintoo.configure do |config|
  #   config.apikey  = ""
  #   config.sandbox = false
  #   config.debug   = true
  # end
  pending "Add your config block in spec/spec_helper.rb"
end
