
require_relative '../lib/minmi'

options = {
  :init_day => Date.new(2016,11,11),
  :database => 'minmi',
  :collection => 'test',
  :last_day => Date.new(2016,11,01),
  :num_threads => 20 # best number hand testing, try with benchmark
}

m = Minmi.new(options)

#actual day test
#puts "actual day is: #{m.day} so the url is #{m.main_url}"
#m.get_links

#change day test
#m.prev_day
#puts "actual day is: #{m.day} so the url is #{m.main_url}"

# links queue test
puts ">>> links queue test:"
m.populate_queue
links = m.test_queue
puts "queue size: #{links.size}"
10.times do
  link = links.pop
  puts "> day: #{link.day}, link: #{link.url}, title:"
  puts link.title
end

# process_queue test
puts ">>> process_queue test"
m.init

