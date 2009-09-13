require "TwitterScrubber"
require "IncludesComparer"
require "TextileWithTimeFormatter"

config = YAML.load(File.open('config.yml'))

if(File.exists?("EngineeringJournal.textile"))
	File.delete("EngineeringJournal.textile")
end

scrubber = TwitterScrubber.new

config.each do |c|
	config[c[0]]["comparer"] = IncludesComparer.new("@projectosl")
	scrubber.Scrub(config[c[0]])
end

twitterOutput = TwitterScrubber.new.Scrub(config["projectosl"]).Scrub(config["hammerdr"]).Format(TextileWithTimeFormatter.new).formattedValues

f = File.new("EngineeringJournal.textile", "w")
f.write(twitterOutput)
f.close()

