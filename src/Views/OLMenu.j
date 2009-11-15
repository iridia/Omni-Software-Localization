@import <AppKit/CPMenu.j>
@import "../Controllers/OLFeedbackController.j"

@implementation OLMenu : CPMenu
{
    OLFeedbackController _feedbackController;
}

- (id)initWithTitle:(CPString)title
{
    self = [super initWithTitle:title];
    
    if (self)
    {
        _feedbackController = [[OLFeedbackController alloc] init];
        var feedbackItem = [[CPMenuItem alloc] initWithTitle:@"Send Feedback" action:@selector(showFeedbackWindow:) keyEquivalent:@"f"];
        [feedbackItem setTarget:_feedbackController];
        
        var feedbackImage = [[CPImage alloc] initWithContentsOfFile:@"Resources/Feedback.png" size:CPMakeSize(24, 24)];
        [feedbackItem setImage:feedbackImage];
        [feedbackItem setAlternateImage:feedbackImage];
        
        [self insertItem:feedbackItem atIndex:0];
    }
    
    return self;
}

@end