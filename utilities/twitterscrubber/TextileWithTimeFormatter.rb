require "TextileFormatter"

class TextileWithTimeFormatter < TextileFormatter
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
		output += "| Date Posted | Message | Time |\n"
		@values.each do |v|
			if(currentUser != v[:user])
				currentUser = v[:user]
				output += "\nh1. " + currentUser + "\n\n"
				output += "| Date Posted | Message | Time |\n"
			end
			
			time = 0
			
			if(v[:message].include?("t:"))
				time = v[:message][/t:\d+/].delete("t:").to_i
			end
			
			output += "|" + v[:date].to_s + "|" + v[:message] + "|" + time.to_s + "|\n"
		end
		
		return output
	end
	
	def matchToWhitespace(message, startIndex)
	end
end