@import <OJMoq/OJMoq.j>
@import <Foundation/CPNotificationCenter.j>

var CPNotificationDefaultCenter = nil;
var isMocked = true;

@implementation CPNotificationCenter (MockDefaultCenter)
    
+ (id)defaultCenter
{
    if(isMocked)
    {
        return moq();
    }
    else
    {
        if (!CPNotificationDefaultCenter)
             CPNotificationDefaultCenter = [[CPNotificationCenter alloc] init];
             
        return CPNotificationDefaultCenter;
    }
}

+ (BOOL)setIsMocked:(BOOL)shouldBeMocked
{
    isMocked = shouldBeMocked;
}

@end