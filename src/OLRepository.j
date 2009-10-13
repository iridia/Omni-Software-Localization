@import <Foundation/CPObject.j>

@implementation OLRepository : CPObject
{
	CPDictionary _singletons; // Dictionary of Objects
}

- (id)init
{
	if(self = [super init])
	{
		_singletons = [CPDictionary dictionary];
	}
	
	return self;
}

- (void)registerSingleton:(id)anObject
{
	[_singletons addObject:anObject forKey:[anObject class]];
}

- (void)getObjectFor:(Class)aClass
{
	if([[_singletons allKeys] containsObject:aClass])
	{
		return [_singletons objectForKey:aClass];
	}
	else
	{
		return nil;
	}
}

@end
