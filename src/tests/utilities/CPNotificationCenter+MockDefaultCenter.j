@import <OJMoq/OJMoq.j>
@import <Foundation/CPNotificationCenter.j>

@implementation CPNotificationCenter (MockDefaultCenter)
    
+ (id)defaultCenter
{
    return moq();
}

@end