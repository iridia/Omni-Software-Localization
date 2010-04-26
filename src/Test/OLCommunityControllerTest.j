@import "utilities/Observer.j"

[CPApplication sharedApplication];

@implementation OLCommunityControllerTest : OJTestCase

- (void)testThatOLCommunityControllerDoesInitialize
{
    [self assertNotNull:[[OLCommunityController alloc] init]];
}

- (void)testThatOLCommunityControllerDoesPostNotificationWhenOutlineViewChanges
{
    var target = [[OLCommunityController alloc] init];
    
    var outlineView = moq();
    
    [outlineView selector:@selector(selectedRowIndexes) returns:[CPIndexSet indexSetWithIndex:1]];
    [outlineView selector:@selector(parentForItem:) returns:target];
    [outlineView selector:@selector(itemAtRow:) returns:@"Inbox"];
    
    var notification = [[CPNotification alloc] initWithName:@"" object:outlineView userInfo:nil];
    
    var observer = [[Observer alloc] init];

    [observer startObserving:@"OLContentViewControllerShouldUpdateContentView"];

    [target didReceiveOutlineViewSelectionDidChangeNotification:notification];

    [self assertTrue:[observer didObserve:@"OLContentViewControllerShouldUpdateContentView"]];
}

- (void)testThatOLCommunityControllerDoesHaveCorrectItemsInList
{
    var target = [[OLCommunityController alloc] init];
    
    [self assert:[@"Inbox", @"Search"] equals:[target sidebarItems]];
}

- (void)testThatOLCommunityControllerDoesHaveCorrectName
{
    var target = [[OLCommunityController alloc] init];
    
    [self assert:@"Community" equals:[target sidebarName]];
}

- (void)testThatOLCommunityControllerDoesExpandOnReload
{
    var target = [[OLCommunityController alloc] init];
    
    [self assert:YES equals:[target shouldExpandSidebarItemOnReload]];
}

@end