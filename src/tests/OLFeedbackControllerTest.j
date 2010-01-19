@import "../Controllers/OLFeedbackController.j"
@import "utilities/CPNotificationCenter+MockDefaultCenter.j"
@import "utilities/OLUserSessionManager+Testing.j"

@implementation OLFeedbackControllerTest : OJTestCase
{
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

- (void)testThatOLFeedbackControllerDoesRespondToUserDidChangeWhenNotLoggedIn
{
  var target = [[OLFeedbackController alloc] init];
  
  var feedbackWindow = moq();
  var emailTextField = moq();
  target._feedbackWindow = feedbackWindow;
  [feedbackWindow selector:@selector(emailTextField) returns:emailTextField];
  [emailTextField expectSelector:@selector(setStringValue:) times:1 arguments:[@""]];
  
  [target userDidChange:moq()];
  
  [emailTextField verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOLFeedbackControllerDoesRespondToUserDidChangeWhenLoggedIn
{
    var target = [[OLFeedbackController alloc] init];

    var feedbackWindow = moq();
    var emailTextField = moq();
    var user = moq();
    var email = @"derek@derek.com";
    target._feedbackWindow = feedbackWindow;
    [feedbackWindow selector:@selector(emailTextField) returns:emailTextField];
    [emailTextField expectSelector:@selector(setStringValue:) times:1 arguments:[email]];
    [[OLUserSessionManager defaultSessionManager] setUser:user];
    [user selector:@selector(email) returns:email];

    [target userDidChange:moq()];

    [emailTextField verifyThatAllExpectationsHaveBeenMet];
}

- (void)tearDown
{
    [OLUserSessionManager resetDefaultSessionManager];
}

// - (void)testThatOLFeedbackControllerDoesRespondToDidSubmitFeedback
// {
//   //TODO
//   var target = [[OLLoginController alloc] init];
//   var registrationInfo = [CPDictionary dictionary];
//   [target didSubmitFeedback];
//   [self assertTrue:YES];
// }

@end