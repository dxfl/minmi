
require 'date'
require 'mechanize'
require_relative 'mongo_interface'
require 'thread'
require 'logger'

LOG = Logger.new($stderr)
LOG.level = Logger.const_get(ENV.fetch("LOG_LEVEL", "INFO"))

class Minmi

  attr_reader :day, :links
  
  def initialize options
    @day = options[:init_day]
    @db_name = options[:database]
    @collection_name = options[:collection]
    @last_day = options[:last_day]
    @num_threads = options[:num_threads]
    @agent = Mechanize.new
    @links_queue = Queue.new
  end

  def day
    @day.strftime("%Y.%m.%d")
  end

  #from last day, yesterday, to the first day
  def prev_day
    @day = @day.prev_day
  end

  def main_url
    "http://transcripts.cnn.com/TRANSCRIPTS/#{day}.html"
  end

  def get_page url
    @agent.get(url)
  end

  Link = Struct.new(:day, :main_url, :url, :title)
  
  #maybe is better to keep with mechanize links so we have the title of the link too
  def get_links
    page = with_error_handling{ get_page main_url }
    clean_links page.links
  end

  def clean_links links
    links.select { |link| link? link }
  end

  def link? link
    if link.href
      if link.href[/^\/TRANSCRIPTS\/(\d+)\//]
        return true
      end
    end
    false
  end

  def populate_queue
    Thread.new do
      while @day >= @last_day
        links_in_main = get_links
        links_in_main.each do |link|
          @links_queue << Link.new(@day.strftime("%Y-%m-%d"), main_url, link.href, link.text)
        end
        prev_day
      end
    end
  end

  #testing purpose only
  def test_queue
    @links_queue
  end

  def connect_mongo
    @mongo = MongoInterface.new(@db_name, @collection_name)
  end

  def clean_text text
    text.gsub(/\t+/, "")
      .gsub(/ +/, " ")[/.*(?<=var CNN)/m]
      .gsub(/var CNN/, "")
      .gsub(/\n+/, "\n")
  end
  
  def get_transcripts url
    with_error_handling{ clean_text(@agent.get(url).at('body').text) }
  end

  def with_error_handling
    yield
  rescue => exception
    LOG.debug "PDF_Error: #{exception.message}"
  end
  
  def process_link link
    text = get_transcripts link.url
    post = { day: link.day,
             main_url: link.main_url,
             url: link.url,
             title: link.title,
             text: text
           }
    with_error_handling{ @mongo.save([post]) }
  end

  # TODO: change to queue & threads
  def process_queue 
    threads = (1..@num_threads).map do
      Thread.new do
        loop do
          process_link @links_queue.pop
          break if @links_queue.empty?
        end
      end
    end
    threads.each(&:join)
  end

  def init
    connect_mongo
    populate_queue
    process_queue
  end
end


