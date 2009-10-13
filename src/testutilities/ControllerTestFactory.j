@import <Foundation/CPObject.j>

@implementation OLControllerTestFactory : CPObject

+ (void)welcomeControllerWithFrame:(CGRect)frame
{
	var contentView = [[CPView alloc] initWithFrame:frame];
	var target = [[OLWelcomeController alloc] initWithContentView:contentView];
}

@end
