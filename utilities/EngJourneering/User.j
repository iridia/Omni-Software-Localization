@import <Foundation/CPObject.j>
@import "UserData.j"

@implementation User : CPObject
{
    CPDictionary handles @accessors;
    CPArray data @accessors(readonly);
}

- (id)initWithHandles:(CPDictionary)someHandles
{
    self = [super init];
    
    if (self)
    {
        data = [];
        [self setHandles:someHandles];
    }
    
    return self;
}

- (void)addData:(UserData)moreData
{
    [data addObject:moreData];
    
    console.log("Adding message:", [moreData text], "for user:", [[self handles] objectForKey:@"github"]);
}

@end