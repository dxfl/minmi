# library for formatting the output on a json file

#require 'json'
require 'date'

module Output
  
  class Txt

    def initialize
      @file = load_file
    end

    def article post
      post[:text]
    end
    
    def load_file
      File.new(filename, 'a')
    end

    def filename
      "cnn_#{Date.today.strftime("%Y%m%d")}"
    end

    def save post
      @file.write(article(post))
    end

    def close_file
      @file.close
    end

  end

  class Json << Txt

    def article post
      post
    end

    def save post
      @file.write(article(post).to_json)
    end
    
  end

  class Mongo << Json
    # to do

    def save_file
      @file

  end
  
end
