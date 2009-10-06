@import <Foundation/CPObject.j>
@import "WikiPageData.j"

@implementation DataController : CPObject
{
    CPArray pages @accessors;
}


- (id)initWithPages:(CPArray)somePages
{
	self = [super init];
	
	if (self) {
		pages = somePages;
	}
	
	return self;
	
}


- (void)connection:(CPJSONPConnection)connection didReceiveData:(CPString)data
{
    console.warn("You should really override me.");
}

- (void)connection:(CPJSONPConnection)connection didFailWithError:(CPString)error
{
    console.error(error);
}

@end