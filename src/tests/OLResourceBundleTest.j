@import "../models/OLResourceBundle.j"
@import "../models/OLLanguage.j"
@import "utilities/OJMoq.j"

@implementation OLResourceBundleTest : OJTestCase

- (void)testThatOLResourceBundleLoads
{
	var resources = [[CPArray alloc] init];
	[self assertNotNull:[[OLResourceBundle alloc] initWithResources:resources ofLanguage:[OLLanguage english]]];
}

- (void)testThatOLResourceBundleDoesLoadWithJustLanguage
{
	[self assertNotNull:[[OLResourceBundle alloc] initWithLanguage:[OLLanguage english]]];
}

- (void)testThatOLResourceBundleDoesAddResources
{
	var mockResource = [OJMoq mockBaseObject:[[OLResource alloc] initWithFilename:@"a" withFileType:"gif" withLineItems:new Array()]];
	var resources = [[CPArray alloc] init];
	var target = [[OLResourceBundle alloc] initWithResources:resources ofLanguage:[OLLanguage english]];
	
	[self assert:[[target resources] count] equals:0];
	[target addResource:mockResource];
	[self assert:[[target resources] count] equals:1];
}

@end