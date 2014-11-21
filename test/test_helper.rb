
require 'mingle-api'
require "minitest/autorun"

def create_basic_auth_mingle
  MingleAPI.new(ENV['MINGLE_SITE'], basic_auth: [ENV['MINGLE_USERNAME'], ENV['MINGLE_PASSWORD']])
end

def create_hmac_auth_mingle
  MingleAPI.new(ENV['MINGLE_SITE'], hmac: [ENV['MINGLE_USERNAME'], ENV['MINGLE_SECRET_KEY']])
end