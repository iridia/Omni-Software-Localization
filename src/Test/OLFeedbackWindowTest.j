@import <OJMoq/OJMoq.j>
@import "../Views/OLFeedbackWindow.j"

CPApp = [CPApplication sharedApplication];

@implementation OLFeedbackWindowTest : OJTestCase

- (void)testThatOLFeedbackWindowDoesInitialize
{
    var target = [[OLFeedbackWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPTitledWindowMask];
    [self assertNotNull:target];
}

// - (void)testThatOLFeedbackWindowDoesCloseWhenCancelled
// {   
//     var target = [[OLFeedbackWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPTitledWindowMask];
//     [target cancel:moq()];
// }

- (void)testThatOLFeedbackWindowDoesSubmitFeedback
{
    var delegate = moq();
    [delegate selector:@selector(didSubmitFeedback:) times:1];
    
    var target = [[OLFeedbackWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPTitledWindowMask];    
    
    [target setDelegate:delegate];
    
    [target submitFeedback:nil];
    
    [self assert:delegate equals:[target delegate]];
    [delegate verifyThatAllExpectationsHaveBeenMet];
}

@end