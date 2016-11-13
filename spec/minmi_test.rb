
require_relative '../lib/minmi'

m = Minmi.new(Date.new(2016,11,05))
puts "actual day is: #{m.day} so the url is #{m.main_url}"
m.get_links

#change day
m.prev_day
puts "actual day is: #{m.day} so the url is #{m.main_url}"

#show links references
puts "links references:"
m.get_links
m.links.each{ |l| puts l.href }
