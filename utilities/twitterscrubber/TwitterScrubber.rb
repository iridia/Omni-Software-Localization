class TwitterScrubber
	attr_accessor :formattedValues
	
	def initialize
		@values = []
		@formattedValues = "Data not found"
	end
	
	def scrub(client, comparer)
		client.timeline_for(:user) do |status|
			if( comparer.valid?(status.text)  )
				@values << { :user => status.user.screen_name, :message => status.text, :date => status.created_at }
			end
		end
		
		return self
	end
	
	def format(formatter)		
		@formattedValues = formatter.format(@values)
		return self
	end
end