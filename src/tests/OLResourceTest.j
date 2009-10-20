@import <AppKit/AppKit.j>
@import "../models/OLResource.j"

@implementation OLResourceTest : OJTestCase

- (void)testThatOLResourceLoads
{
	var fileName = @"fileName";
	var someLineItems = new Array("1","2","3");
	var fileType = @".jar";
	
	var resource = [[OLResource alloc] initWithFilename:fileName withFileType:fileType withLineItems:someLineItems];
		
	[self assert:fileName equals:[resource fileName]];
	[self assert:someLineItems equals:[resource lineItems]];
	[self assert:fileType equals:[resource fileType]];
}

@end