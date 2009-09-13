class IncludesComparer
	def initialize(includedText)
		@includedText = includedText
	end
	
	def Valid?(value)
		return value.include?(@includedText)
	end
end