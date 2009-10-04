@import <Foundation/CPObject.j>
@import "OLResource.j"

/*!
 * The OLResourceController is a controller for the resource view and
 * the decisions on which data to send to the view is made here.
 */
@implementation OLResourceController : CPObject
{
	CPArray		_resources	@accessors(property=resources);
}

- (id)init
{
	if(self = [super init])
	{
		// adding temp resources
		_resources = [[CPArray alloc] init];
		var array = new Array("1","2","3");
		var tempObject = [[OLResource alloc] initWithFilename:@"test.plist" withTags:array withFileType:@"plist"];
		[_resources addObject:tempObject];
		
		var tempObject = [[OLResource alloc] initWithFilename:@"test.xml" withTags:array withFileType:@"xml"];
		[_resources addObject:tempObject];
		
		var tempObject = [[OLResource alloc] initWithFilename:@"test.j" withTags:array withFileType:@"j"];
		[_resources addObject:tempObject];
		
		var tempObject = [[OLResource alloc] initWithFilename:@"test.js" withTags:array withFileType:@"js"];
		[_resources addObject:tempObject];
		
		var tempObject = [[OLResource alloc] initWithFilename:@"test.awesome" withTags:array withFileType:@"awesome"];
		[_resources addObject:tempObject];
		
		var tempObject = [[OLResource alloc] initWithFilename:@"test.bob" withTags:array withFileType:@"bob"];
		[_resources addObject:tempObject];
		
		var tempObject = [[OLResource alloc] initWithFilename:@"test.tom" withTags:array withFileType:@"tom"];
		[_resources addObject:tempObject];
		
		var tempObject = [[OLResource alloc] initWithFilename:@"tom.plist" withTags:array withFileType:@"plist"];
		[_resources addObject:tempObject];
		
		var tempObject = [[OLResource alloc] initWithFilename:@"jerry.plist" withTags:array withFileType:@"plist"];
		[_resources addObject:tempObject];
		
		var tempObject = [[OLResource alloc] initWithFilename:@"chandler.plist" withTags:array withFileType:@"plist"];
		[_resources addObject:tempObject];
		
		var tempObject = [[OLResource alloc] initWithFilename:@"derek.plist" withTags:array withFileType:@"plist"];
		[_resources addObject:tempObject];
		
		var tempObject = [[OLResource alloc] initWithFilename:@"caleb.plist" withTags:array withFileType:@"plist"];
		[_resources addObject:tempObject];
	}
	return self;
}

- (int)numberOfRowsInTableView:(CPTableView)view
{
	return [_resources count];
}

- (id)tableView:(CPTableView)view objectValueForTableColumn:(CPTableColumn)column row:(int)row
{	
	return [view expectedDataFromResource:[_resources objectAtIndex:row]];
}

@end
