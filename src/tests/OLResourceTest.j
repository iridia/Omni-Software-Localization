@import <AppKit/AppKit.j>
@import "../models/OLResource.j"

@implementation OLResourceTest : OJTestCase

- (void)testThatOLResourceLoads
{
	var fileName = @"fileName";
	var tags = new Array("1","2","3");
	var fileType = @".jar";
	
	var resource = [[OLResource alloc] initWithFilename:fileName withTags:tags withFileType:fileType];
	
	[self assert:fileName equals:[resource fileName]];
	[self assert:tags equals:[resource tags]];
	[self assert:fileType equals:[resource fileType]];
}

@end