@import <Foundation/CPObject.j>

@implementation OLProjectSearchController : CPObject
{
    CPArray                 projects;
    OLProjectSearchView     view;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        projects = [CPArray array];
        view = [[CPView alloc] initWithFrame:CGRectMakeZero()];
    }
    return self;
}

- (id)loadProjects
{
    [OLProject findAllProjectNamesWithCallback:function(project){[self addProject:project];}];
}

- (void)addProject:(OLProject)aProject
{
    [projects addObject:aProject];
//    [view reloadData:self];
}

- (OLProject)projectAtIndex:(int)index
{
    return [projects objectAtIndex:index];
}

@end

@implementation OLProjectSearchController (ProjectSearchDataSource)

- (int)numberOfRowsInTableView:(CPTableView)resourceTableView
{
    return [projects count];
}

- (id)tableView:(CPTableView)tableView objectValueForTableColumn:(CPTableColumn)tableColumn row:(int)row
{
    return [[projects objectAtIndex:row] name];
}

@end