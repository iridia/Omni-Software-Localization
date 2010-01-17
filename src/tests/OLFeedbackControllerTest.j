@import "../Controllers/OLFeedbackController.j"
@import "utilities/CPNotificationCenter+MockDefaultCenter.j"

@implementation OLFeedbackControllerTest : OJTestCase
{
    id tempCPApp;
}

- (void)setUp
{
    CPApp = moq();
    CPApp._windows = moq();
}

- (void)testThatOLFeedbackControllerDoesInitialize
{
  var target = [[OLFeedbackController alloc] init];
  [self assertNotNull:target];
}

- (void)testThatOLFeedbackControllerDoesRespondToShowFeedbackWindow
{
  var target = [[OLFeedbackController alloc] init];
  [target showFeedbackWindow:moq()];    
  [self assertTrue:YES];
}

- (void)testThatOLFeedbackControllerDoesRespondToWillCreateRecord
{
  var target = [[OLFeedbackController alloc] init];
  [target willCreateRecord:moq()];
  [self assertTrue:YES];
}

- (void)testThatOLFeedbackControllerDoesRespondToDidCreateRecord
{
  var target = [[OLFeedbackController alloc] init];
  [target didCreateRecord:moq()];
  [self assertTrue:YES];
}
// 
// - (void)testThatOLFeedbackControllerDoesRespondToUserDidChange
// {
//   //TODO
//   var target = [[OLLoginController alloc] init];
//   
//   [target userDidChange];
//   [self assertTrue:YES];
// }
// 
// - (void)testThatOLFeedbackControllerDoesRespondToDidSubmitFeedback
// {
//   //TODO
//   var target = [[OLLoginController alloc] init];
//   var registrationInfo = [CPDictionary dictionary];
//   [target didSubmitFeedback];
//   [self assertTrue:YES];
// }

@end