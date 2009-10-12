@import <Foundation/CPObject.j>

@implementation OJMoq : CPObject
{
	CPObject	_baseObject		@accessors(readonly, property=object);
	CPArray		_selectors;
	CPDictionary _timesSelectorHasBeenCalled;
	CPArray		_expectations;
}

- (id)initWithBaseObject:(CPObject)baseObject
{
	if(self = [super init])
	{
		_baseObject = baseObject;
	}
	return self;
}

- (id)expectThatSelector:(SEL)selector isCalled:(int)times
{
	[_expectations addObject:function(){ if(_timesSelectorHasBeenCalled[selector] == times) {  return true; } else { assertFailed("Failed!"); return false; } }];
	
	return self;
}

- (id)verifyThatAllExpectationsHaveBeenMet
{
	for(var i = 0; i < [_expectations size]; i++)
	{
		_expectations[i]();
	}
	
	return self;
}

- (id)doesNotRecognizeSelector:(SEL)aSelector
{
	if([_baseObject respondsToSelector:aSelector])
	{
		if([[_timesSelectorHasBeenCalled allKeys] containsObject:aSelector])
		{
			[_timesSelectorHasBeenCalled setObject:[_timesSelectorHasBeenCalled valueForKey:aSelector]+1 forKey:aSelector];
		}
		else
		{
			[_timesSelectorHasBeenCalled setObject:1 forKey:aSelector];
		}
		return [CPObject init];
	}
	else
	{
		CPLog("The base object does not have that selector!");
		[super doesNotRecognizeSelector:aSelector];
	}
}

@end

function assertFailed(message)
{
	throw message;
}
