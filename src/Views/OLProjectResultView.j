@import "OLProjectView.j"

@implementation OLProjectResultView : OLProjectView
{
    id  backButtonDelegate  @accessors;
}

- (CPView)backView
{
    var button = [CPButton buttonWithTitle:@"Back"];
    [button setTarget:self];
    [button setAction:@selector(back:)];
    return button;
}

- (void)back:(id)sender
{
    if ([backButtonDelegate respondsToSelector:@selector(back:)])
    {
        [backButtonDelegate back:self];
    }
}

- (void)reloadTitle
{
    if(titleDataSource && ownerDataSource)
    {
        [self setTitle:[CPString stringWithFormat:@"%@'s %@", [ownerDataSource owner], [titleDataSource title]]];
    }
}

@end
