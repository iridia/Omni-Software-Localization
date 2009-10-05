@import <AppKit/CPDocument.j>
@import <Foundation/CPObject.j>

@implementation CPYaml : CPObject
{
	CPArray keys @accessors(readonly);
	CPArray values @accessors(readonly);
	CPArray pairs @accessors(readonly);
}

- (id)initWithDocument:(CPDocument)aDocument
{
	if(self = [super init])
	{
		document = aDocument;
	}
	return self;
}

@end
