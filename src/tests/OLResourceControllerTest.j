@import "../controllers/OLResourceController.j"
@import "utilities/ojmoq/OJMoq.j"

@implementation OLResourceControllerTest : OJTestCase

- (void)testThatOLResourceControllerLoads
{
	[self assertNotNull:[[OLResourceController alloc] init]];
}

- (void)testThatOLResourceControllerDoesRespondToNumberOfRowsInTableView
{
	var baseObject = [[OLStructureTableView alloc] init];
	var moqTableView = [[OJMoq alloc] initWithBaseObject:baseObject];
	
	var target = [[OLResourceController alloc] init];
	[self assert:[OLResourceController numberOfRowsInTableView:moqTableView]];
}

- (void)testThatOLResourceControllerDoesRespondToTableViewObjectForColumnRow
{
	var baseObject = [[OLStructureTableView alloc] init];
	var moqTableView = [[OJMoq alloc] initWithBaseObject:baseObject];
	
	var target = [[OLResourceController alloc] init];
	[self assert:[OLResourceController tableView:moqTableView objectValueForColumn:1 row:0]];
}



@end