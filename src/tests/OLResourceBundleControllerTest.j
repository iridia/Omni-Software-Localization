@import "../controllers/OLResourceBundleController.j"
@import <OJMoq/OJMoq.j>

@implementation OLResourceBundleControllerTest : OJTestCase


- (void)testThatOLResourceBundleControllerDoesInit
{
	[self assertNotNull:[[OLResourceBundleController alloc] init]];
}

- (void)testThatOLResourceBundleControllerDoesLoadBundles
{
	var array = [CPArray array];
	var originalClass = OLResourceBundle;
	OLResourceBundle = moq();
	
	[OLResourceBundle expectSelector:@selector(list) times:1];
	[OLResourceBundle selector:@selector(list) returns:array];
	
	var target = [[OLResourceBundleController alloc] init];
	
	[target loadBundles];
	
	[self assert:array equals:[target bundles]];
	
	[OLResourceBundle verifyThatAllExpectationsHaveBeenMet];
	
	OLResourceBundle = originalClass;
}


- (void)testThatOLResourceBundleControllerDoesLoadBundlesWithSeveralArrayObjects
{
	var array = [CPArray arrayWithObjects:@"A", @"B", @"C"];
	var originalClass = OLResourceBundle;
	OLResourceBundle = moq();
	
	[OLResourceBundle expectSelector:@selector(list) times:1];
	[OLResourceBundle selector:@selector(list) returns:array];
	
	var target = [[OLResourceBundleController alloc] init];
	
	[target loadBundles];
	
	[self assert:array equals:[target bundles]];
	
	[OLResourceBundle verifyThatAllExpectationsHaveBeenMet];
	
	OLResourceBundle = originalClass;
}


- (void)testThatOLResourceBundleControllerDoesVoteUp
{
	var resourceMock = moq();
	
	var target = [[OLResourceBundleController alloc] init];
	
	[resourceMock expectSelector:@selector(voteUp) times:1];
	
	[target voteUpResource:resourceMock];
	
	[resourceMock verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOLResourceBundleControllerDoesVoteDown
{
	var resourceMock = moq();
	
	var target = [[OLResourceBundleController alloc] init];
	
	[resourceMock expectSelector:@selector(voteDown) times:1];
	
	[target voteDownResource:resourceMock];
	
	[resourceMock verifyThatAllExpectationsHaveBeenMet];
}


- (void)testThatOLResourceBundleControllerDoesSelectBundleAtIndex
{
	var array = [CPArray arrayWithObjects:@"A", @"B", @"C"];
	var originalClass = OLResourceBundle;
	OLResourceBundle = moq();

	[OLResourceBundle selector:@selector(list) returns:array];
	
	var target = [[OLResourceBundleController alloc] init];
	
	[target loadBundles];
	
	[target didSelectBundleAtIndex:1];
	
	[self assert:@"B" equals:[target editingBundle]];
	
	OLResourceBundle = originalClass;
}


- (void)testThatOLResourceBundleControllerDoesEditResourceForEditingBundle
{
	var target = [[OLResourceBundleController alloc] init];
	
	var editingBundle = moq();
	
	[target setEditingBundle:editingBundle];
	
	[editingBundle expectSelector:@selector(replaceObjectInResourcesAtIndex:withObject:) times:1
		arguments:[0, @"something"]];
	[editingBundle expectSelector:@selector(save) times:1];
	
	[target didEditResourceForEditingBundle:@"something"];
	
	[editingBundle verifyThatAllExpectationsHaveBeenMet];
}



@end