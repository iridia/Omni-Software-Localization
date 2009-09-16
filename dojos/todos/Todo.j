@import <Foundation/CPObject.j>

@implementation Todo : CPObject
{
    CPString _text @accessors(property=text);
    bool _finished @accessors(property=isFinished);
}

- (id)init
{
    return [self initWithText:@""];
}

- (id)initWithText:(CPString)someText
{
    self = [super init];
    
    if (self)
    {
        [self setText:someText];
        [self setIsFinished:NO];
    }
    
    return self;
}

- (CPString)description
{
    return [self text] + [self isFinished];
}


@end