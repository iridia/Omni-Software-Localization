@import <AppKit/AppKit.j>
@import <AppKit/CPControl.j>
@import "../Controllers/OLSidebarController.j"
@import <OJMoq/OJMoq.j>

@implementation OLSidebarControllerTest : OJTestCase

- (void)testThatOLSidebarControllerDoesInitialize
{
    var target = [[OLSidebarController alloc] init];
    [self assertNotNull:target];
}

- (void)testThatOLSidebarControllerDoesAwakeFromCib
{
    var target = [[OLSidebarController alloc] init];
    
    // This hack is to make it pass, otherwise we will be trying to init with a nil frame
    // and since it is a javascript object, it won't be accessed like a CPObject, and throw
    // errors.
    target.sidebarScrollView = moq();
    [target.sidebarScrollView selector:@selector(bounds) returns:CGRectMakeZero()];
    
    [target awakeFromCib];
    
    [self assertTrue:YES];
}

- (void)testThatOLSidebarControllerDoesDetermineIfWeShouldSelectARow
{
    var target = [[OLSidebarController alloc] init];
    
    [self assertFalse:[target outlineView:target.sidebarOutlineView shouldSelectRow:0]];
}

- (void)testThatOLSidebarControllerDoesAddItems
{
    var target = [[OLSidebarController alloc] init];
    
    target.sidebarScrollView = moq();
    [target.sidebarScrollView selector:@selector(bounds) returns:CGRectMakeZero()];
    
    [target awakeFromCib];
    [target addSidebarItem:@"Test"];
    
    [self assert:1 equals:[target.sidebarItems count]];
}

- (void)testThatOLSidebarControllerDoesGetChildrenOfItem
{
    var target = [[OLSidebarController alloc] init];
    
    var item = moq();
    
    [item selector:@selector(sidebarItems) returns:["Test"]];
    
    [self assert:[@"Test"] equals:[target childrenOfItem:item]];
}

- (void)testThatOLSidebarControllerDoesReturnGivenIndexOfChildForItem
{
    var target = [[OLSidebarController alloc] init];
    
    var item = moq();
    
    [item selector:@selector(sidebarItems) returns:[@"Test"]];
    
    [self assert:@"Test" equals:[target outlineView:nil child:0 ofItem:item]];
}

@end