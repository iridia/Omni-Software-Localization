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
            
            timeInHours = "0"
            timeInMinutes = "0"
            
            if(v[:message].include?("t:") && /.*t:(\d+)h(\d+)m/.match(v[:message]))
                timeInHours = v[:message].gsub(/.*t:(\d+)h(\d+)m/, '\1')
                timeInMinutes = v[:message].gsub(/.*t:(\d+)h(\d+)m/, '\2')
            end
            
            output += "|" + v[:date].to_s + "|" + v[:message] + "|" + timeInHours + 
                " hours, " + timeInMinutes + " minutes|\n"
        end
        
        return output
    end
end