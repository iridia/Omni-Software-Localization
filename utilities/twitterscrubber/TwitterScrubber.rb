require "rubygems"
require "twitter"
require "IncludesComparer"
require "TextileFormatter"

class TwitterScrubber
	attr_accessor :formattedValues
	
	def initialize
		@values = []
		@formattedValues = "Data not found"
	end
	
	def Scrub(config)
		client = Twitter::Client.new(:login => config["username"], :password => config["password"])
		timeline = client.timeline_for(:user) do |status|
			if( config["comparer"].Valid?(status.text)  )
				@values << { :user => config["username"], :message => status.text, :date => status.created_at }
			end
		end
		
		return self
	end
	
	def Format(formatter)		
		@formattedValues = formatter.format(@values)
		return self
	end
end