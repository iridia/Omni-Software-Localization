@import "../models/OLApplication.j"
@import "utilities/OJMoq.j"

@implementation OLApplicationTest : OJTestCase

- (void)testThatOLApplicationLoads
{
	[self assertNotNull:[[OLApplication alloc] initWithName:@"Test"]];
}

- (void)testThatOLApplicationDoesSetName
{
	var target = [[OLApplication alloc] initWithName:@"Test"];
	[self assert:[target name] equals:@"Test"];
}

- (void)testThatOLApplicationDoesInitializeResourceBundles
{
	var target = [[OLApplication alloc] initWithName:@"Test"];
	[self assertNotNull:[target resourceBundles]];
}

- (void)testThatOLApplicationDoesAddResourceBundle
{
	var mockBundle = [OJMoq mockBaseObject:[[OLResourceBundle alloc] initWithLanguage:[OLLanguage english]]];
	var target = [[OLApplication alloc] initWithName:@"Test"];
	[self assert:[[target resourceBundles] count] equals:0];
	[target addResourceBundle:mockBundle];
	[self assert:[[target resourceBundles] count] equals:1];
}

- (void)testThatOLApplicationDoesGetTheResourceBundleOfSpecifiedLanguage
{
	var alanguage = [OLLanguage english];
	var mockBundle = [OJMoq mockBaseObject:[[OLResourceBundle alloc] initWithLanguage:alanguage]];
	[mockBundle selector:@selector(language) returns:alanguage];
	
	var target = [[OLApplication alloc] initWithName:@"Test"];
	[target addResourceBundle:mockBundle];
	
	[self assert:[target getResourceBundleOfLanguage:alanguage] equals:mockBundle];
}


@end