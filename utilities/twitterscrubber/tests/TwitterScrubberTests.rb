require 'test/unit'
require 'flexmock/test_unit'
require "../TwitterScrubber"

class TwitterScrubberTests < Test::Unit::TestCase
	def test_ThatFormattedValuesIsInitializedToDataNotFound
		target = TwitterScrubber.new
		
		assert( target.formattedValues == "Data not found", "formattedValues not initialized properly" )
	end
	
	def test_ThatScrubCallsTimelineFor
		target = TwitterScrubber.new
		
		client = flexmock("temp")
		client.should_receive(:timeline_for).and_return([])
		
		target.scrub(client, nil)
	end
	
	def test_ThatScrubCallsValid
		target = TwitterScrubber.new
		
		client = flexmock("temp")
		client.should_receive(:timeline_for).and_return([flexmock("temp")])
		
		comparer = flexmock("temp")
		comparer.should_receive(:valid?).and_return(false)
		
		target.scrub(client, comparer)
	end
	
	def test_ThatFormatChangesFormattedValues
		target = TwitterScrubber.new
		
		formatter = flexmock("temp")
		formatter.should_receive(:format).and_return("Test")
		
		assert( target.format(formatter).formattedValues == "Test", "Should have formatted values" )
	end
end
