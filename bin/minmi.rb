
require_relative '../lib/minmi'

options = {
  :init_day => Date.new(2016,11,12),
  :database => 'minmi',
  :collection => 'minmi',
  :last_day => Date.new(2000,01,01),
  :num_threads => 20
}

puts ">>> starting extraction"

m = Minmi.new(options)
m.init

puts ">>> the end, time is: #{Time.now}"
