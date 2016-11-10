
require 'date'
require 'mechanize'

class Minmi

  attr_reader :day, :links
  
  def initialize init_day
    @day = init_day
    @agent = Mechanize.new
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

  #maybe is better to keep with mechanize links so we have the title of the link too
  def get_links
    page = get_page main_url
    @links = clean_links page.links
  end

  def clean_links links
    links.select { |link| is_link? link }
  end

  def is_link? link
    if link.href
      if link.href[/^\/TRANSCRIPTS\/(\d+)\//]
        return true
      end
    end
    false
  end
  
  def get_transcripts url
    @agent.get(url).at('body').text
  end
  
  
end


