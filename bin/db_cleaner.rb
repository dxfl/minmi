
require 'mongo'

dbname = "minmi"
collectionname = "minmi"

client = Mongo::Client.new(['127.0.0.1'], :database => dbname)
collection = client[collectionname]

collection.find.each do |article|
  text = article[:text].gsub(/\t+/, "")
         .gsub(/ +/, " ")[/.*(?<=var CNN)/m]
         .gsub(/var CNN/, "")
         .gsub(/\n+/, "\n")
#  collection.update_one({ "_id" => article["_id"]}, {:text => text})
end

