require "rubygems"
require "twitter"
require "TwitterScrubber"
require "IncludesComparer"
require "TextileWithTimeFormatter"

config = YAML.load(File.open('config.yml'))
targetFileName = "EngineeringJournal.textile"

if(File.exists?(targetFileName))
	File.delete(targetFileName)
end

scrubber = TwitterScrubber.new
comparer = IncludesComparer.new("@projectosl")

config.each do |c|
	client = Twitter::Client.new(:login => config[c[0]]["username"], :password => config[c[0]]["password"])
	scrubber.scrub(client, comparer)
end

twitterOutput = scrubber.format(TextileWithTimeFormatter.new).formattedValues

f = File.new(targetFileName, "w")
f.write(twitterOutput)
f.close

