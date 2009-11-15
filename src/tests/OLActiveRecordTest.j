@import "../Models/OLActiveRecord.j"
@import <AppKit/AppKit.j>
@import "utilities/OJMoq/OJMoq.j"

@implementation OLActiveRecordTest : OJTestCase

- (void)testThatOLActiveRecordDoesInitialize
{
	var target = [[OLActiveRecord alloc] init];
	[self assertNotNull:target];
}

- (void)testThatOLActiveRecordDoesTryToGrabAList
{
	[self assertNotNull:[OLActiveRecord list]]
}

- (void)testThatOLActiveRecordDoesFindByRecordId
{
	[self assertNotNull:[OLActiveRecord findByRecordID:@"aRecordId"]];
}

- (void)testThatOLActiveRecordDoesGet
{
	var target = [[OLActiveRecord alloc] init];
	[self assertNotNull:[target get]];
}

- (void)testThatOLActiveRecordDoesSave
{
	var target = [[OLActiveRecord alloc] init];
	[target save];
	[self assertTrue:YES];
}

- (void)testThatOLActiveRecordDoesCreate
{
	var target = [[OLActiveRecord alloc] init];
	[target _create];
	[self assertTrue:YES];
}

- (void)testThatOLActiveRecordDoesRecieveData
{
	var target = [[OLActiveRecord alloc] init];
	[target connection:moq() didReceiveData:moq()];
	[self assertTrue:YES];
}

- (void)testThatOLActiveRecordDoesDelete
{
	var target = [[OLActiveRecord alloc] init];
	[target delete];
	[self assertTrue:YES];
}

- (void)testThatOLActiveRecordDoesGiveBackCorrectAPIValue
{
	var target = [[OLActiveRecord alloc] init];
	[target setRecordID:@"1"];
	var actual = [target apiURLWithRecordID:YES];
	[self assert:actual equals:[CPURL URLWithString:@"api/activerecord/1"]];
}

- (void)testThatOLActiveRecordDoesGiveBackCorrectAPIValueWithNoID
{
	var target = [[OLActiveRecord alloc] init];
	var actual = [target apiURLWithRecordID:NO];
	[self assert:actual equals:[CPURL URLWithString:@"api/activerecord"]];
}

@end