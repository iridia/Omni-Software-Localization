@import <Foundation/CPObject.j>
@import "UserData.j"

@implementation User : CPObject
{
    CPDictionary handles @accessors;
    CPString name @accessors;
    CPArray data @accessors(readonly);
}

- (id)initWithName:(CPString)aName handles:(CPDictionary)someHandles
{
    self = [super init];
    
    if (self)
    {
        data = [];
        [self setHandles:someHandles];
        [self setName:aName];
    }
    
    return self;
}

- (void)addData:(UserData)moreData
{
    [data addObject:moreData];
}

@end