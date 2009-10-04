@import <Foundation/CPObject.j>
@import "WikiPageData.j"

@implementation WikiPage : CPObject
{
	CPString name @accessors(readonly);
	CPString path @accessors(readonly);
	CPArray data @accessors(readonly);
}

- (id)initWithName:(CPString)aName withPath:(CPString)aPath
{
	self = [super init];
	
	if (self)
	{
		data = [];
		name = aName;
		path = aPath;
	}
	
	return self;
}

- (void)addData:(WikiPageData)moreData
{
	[data addObject:moreData];
}

@end