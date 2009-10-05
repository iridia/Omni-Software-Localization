@import <Foundation/CPObject.j>
@import "WikiPageData.j"

@implementation WikiPage : CPObject
{
	CPString name @accessors(readonly);
	CPString path @accessors(readonly);
	CPArray actionItems @accessors(readonly);
}

- (id)initWithName:(CPString)aName withPath:(CPString)aPath
{
	self = [super init];
	
	if (self)
	{
		actionItems = [];
		name = aName;
		path = aPath;
	}
	
	return self;
}

- (void)addActionItem:(ActionItem)actionItem
{
	[actionItems addObject:actionItem];
}

@end