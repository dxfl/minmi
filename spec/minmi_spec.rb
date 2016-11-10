# coding: utf-8
require 'minmi'

RSpec.describe Minmi do
 
  before(:each) do
    @m = Minmi.new(Date.new(2016,11,05))
  end
  
  it "starts from a day" do    
    expect(@m.day).to eq("2016.11.05")
  end

  it "moves one day each step" do
    @m.prev_day
    expect(@m.day).to eq("2016.11.04")
  end

  it "prepares the url to visit" do
    expect(@m.url).to eq("http://transcripts.cnn.com/TRANSCRIPTS/2016.11.05.html")
  end

  it "gets the main transcript page of that day" do
    @m.get_links
    expect(@m.links).to include("http://transcripts.cnn.com/TRANSCRIPTS/1611/05/cnr.01.html")
  end

  it "gets all the links from the main page"

  it "follows the link and extracts its text"

  it "creates the data structure for storing with title, date, text"
end
