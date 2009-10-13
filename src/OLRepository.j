@import <Foundation/CPObject.j>

@implementation OLRepository : CPObject
{
	CPDictionary _singletons; // Dictionary of Objects
	CPDictionary _factoryMethods; // Dictionary of Factory Methods
}

- (id)init
{
	if(self = [super init])
	{
		_singletons = [CPDictionary dictionary];
		_factoryMethods = [CPDictionary dictionary];
	}
	
	return self;
}

@end
