@import <Foundation/CPString.j>

@implementation CPString (OSL)

- (CPNumber)findTimeInString
{
    var timeRegEx = new RegExp(".*t:(\\d+)h(\\d+)m", "gi");
    
    var time = 0;
    
    var matches = timeRegEx.exec(self);
    if (matches) {
        time = 60 * parseInt(matches[1]) + parseInt(matches[2]);
    }
    
    return time;
}

- (CPString)removeOccurencesOfString:(CPString)removeString
{
    return [self stringByReplacingOccurrencesOfString:removeString withString:""];
}

- (CPDate)convertToDate
{
    var components = [self componentsSeparatedByString:@"-"];
    
    if (components)
    {
        var date = new Date(components[0], components[1] - 1, components[2].substring(0, 2));
        return date;
    }
    
    return nil;
}

@end