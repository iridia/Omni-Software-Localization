@import "../Controllers/OLContentViewController.j"
@import <AppKit/CPView.j>
@import <OJMoq/OJMoq.j>

@implementation OLContentViewControllerTest : OJTestCase
{
    OLContentViewController testContentViewController;
}

- (void)setUp
{
    testContentViewController = [[OLContentViewController alloc] init];
}

- (void)testThatOLContentViewControllerDoesInitialize
{
	[self assertNotNull:testContentViewController];
}

- (void)testThatOLContentViewControllerDoesSetCurrentView
{
    var view = moq();
    var contentView = moq();
    
    testContentViewController.contentView = contentView;
    
    [view selector:@selector(setFrame:) times:1];
    [contentView selector:@selector(addSubview:) times:1 arguments:[view]];
    
    [testContentViewController setCurrentView:view];
    
    [view verifyThatAllExpectationsHaveBeenMet];
    [contentView verifyThatAllExpectationsHaveBeenMet];
    [self assert:view equals:testContentViewController.currentView];
}

- (void)testThatOLContentViewControllerDoesRemoveCurrentView
{
    var view = moq();
    var view2 = moq();
    
    [view selector:@selector(removeFromSuperview) times:1];
    
    [testContentViewController setCurrentView:view];
    [testContentViewController setCurrentView:view2];
    
    [view verifyThatAllExpectationsHaveBeenMet];
}

@end