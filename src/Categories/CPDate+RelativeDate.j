var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

@implementation CPDate (RelativeDate)

- (CPString)getRelativeDateStringFromDate:(CPDate)anotherDate
{
    if (self.getDate() === anotherDate.getDate()) // Same day
    {
        var hour = self.getHours();
        var am_or_pm = (hour < 12) ? @"AM" : @"PM";
        hour = hour % 12;
        if (hour === 0) // correct for 12 AM being 0
        {
            hour = 12;
        }
        
        var minutes = self.getMinutes();
        minutes = (minutes < 10) ? ("0" + minutes) : ("" + minutes);
        
        return [CPString stringWithFormat:@"%d:%s %s", hour, minutes, am_or_pm];
    }
    
    if (self.getDate() + 1 === anotherDate.getDate()) // Yesterday
    {
        return @"Yesterday";
    }
    
    // Before that
    var month = months[self.getMonth()];
    var day = self.getDate();
    var year = self.getFullYear();
    
    return [CPString stringWithFormat:@"%s %d, %d", month, day, year];
}

@end