# library for formatting the output on a json file

#require 'json'
require 'date'

module Output
  
  class Txt

    def initialize post
      @post = post
      @file = load_file
    end

    def article
      post[:text]
    end
    
    def load_file
      File.new(filename, 'a')
    end

    def filename
      "cnn_#{Date.today.strftime("%Y%m%d")}"
    end

    def save_file
      @file.write(article)
    end

    def close_file
      @file.close
    end

  end

  class Json << Txt

    def article
      post
    end

    def save_file
      @file.write(post.to_json)
    end
    
  end
  
end
