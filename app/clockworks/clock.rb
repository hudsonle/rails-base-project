# frozen_string_literal: trueProduct

require 'clockwork'
require './config/environment'
include Clockwork

handler do |job, time|
  puts "Running #{job}, at #{time}"
end


