
require_relative '../lib/minmi'

m = Minmi.new(Date.new(2016,11,05))
puts "actual day is: #{m.day} so the url is #{m.url}"
#puts m.links
puts m.get_links
m.prev_day
puts "actual day is: #{m.day} so the url is #{m.url}"
puts m.links
