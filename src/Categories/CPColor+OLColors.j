@implementation CPColor (OLColors)

+ (CPColor)sourceViewColor
{
    return [CPColor colorWithCalibratedRed:0.840 green:0.868 blue:0.899 alpha:1.000];
}

+ (CPColor)errorColor
{
    return [CPColor redColor];
}

+ (CPColor)highlightColor
{
    return [CPColor colorWithCalibratedRed:1.000 green:1.000 blue:0.000 alpha:0.350];
}

@end