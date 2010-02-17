@import <AppKit/CPView.j>

@implementation OLCommentView :CPView
{
    CPTextField     user;
    CPTextField     comment;
    CPView          padding;
}

- (void)setRepresentedObject:(OLComment)aComment
{
    if (!padding)
    {
        padding = [[CPView alloc] initWithFrame:CGRectInset([self bounds], 5.0, 0.0)];
        var image = [[CPThreePartImage alloc] initWithImageSlices:[
                                [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/thoughtbubble-0.png" size:CGSizeMake(24.0, 80.0)],
                                [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/thoughtbubble-1.png" size:CGSizeMake(27.0, 80.0)],
                                [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/thoughtbubble-2.png" size:CGSizeMake(48.0, 80.0)]
                             ] isVertical:NO];
        [padding setBackgroundColor:[CPColor colorWithPatternImage:image]];
        [padding setAutoresizingMask:CPViewWidthSizable];
        [self addSubview:padding];
    }
    if (!user)
    {
        user = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
        [user setAutoresizingMask:CPViewMinXMargin | CPViewMinYMargin];
        [user setFont:[CPFont boldSystemFontOfSize:12.0]];
        [padding addSubview:user];
    }
    if (!comment)
    {
        comment = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
        [comment setFont:[CPFont systemFontOfSize:12.0]];
        [padding addSubview:comment];
    }
    
    [user setStringValue:[aComment userEmail]];
    [user sizeToFit];
    [user setFrameOrigin:CPMakePoint([self bounds].size.width - [user bounds].size.width - 72.0, [self bounds].size.height - [user bounds].size.height)];
    
    [comment setStringValue:[aComment content]];
    [comment sizeToFit];
    [comment setFrameOrigin:CPMakePoint(12.0, 12.0)];
}

@end