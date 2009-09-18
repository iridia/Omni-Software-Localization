require 'test/unit'
require 'flexmock/test_unit'
require "../IncludesComparer"

class IncludesComparerTests < Test::Unit::TestCase
   def test_ThatIncludesComparerReturnsFalse
       target = IncludesComparer.new("@projectosl")
       
       assert( !target.valid?("shouldnotbevalid"), "Did not return invalid value!" )
   end
   
   def test_ThatIncludesComparerReturnsTrue
      target = IncludesComparer.new("@projectosl") 
      
      assert( target.valid?("shouldbevalid @projectosl"), "Did not return valid value!" )
   end
end