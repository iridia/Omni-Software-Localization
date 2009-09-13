class TextileFormatter
	def format(values)
		@values = values
		@values.sort { |x,y| x[:user] <=> y[:user] }
		return parseData()
	end
	
	private
	def parseData
		output = ""
		
		currentUser = @values[0][:user]
		output += "h1. " + currentUser + "\n\n"
		output += "| Date Posted | Message |\n"
		@values.each do |v|
			if(currentUser != v[:user])
				currentUser = v[:user]
				output += "\nh1. " + currentUser + "\n\n"
				output += "| Date Posted | Message |\n"
			end
			
			output += "|" + v[:date].to_s + "|" + v[:message] + "|\n"
		end
		
		return output
	end
end