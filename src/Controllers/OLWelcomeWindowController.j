@import <AppKit/CPWindowController.j>

@implementation OLWelcomeWindowController : CPWindowController
{
    @outlet CPTextField     welcomeText;
}

- (id)init
{
    if (self = [super initWithWindowCibName:@"WelcomeWindow" owner:self])
    {
        console.log("Hello, world");
    }
    return self;
}

@end
