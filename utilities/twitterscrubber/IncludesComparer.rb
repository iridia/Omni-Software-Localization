class IncludesComparer
	def initialize(includedText)
		@includedText = includedText
	end
	
	def valid?(value)
		return value.include?(@includedText)
	end
end