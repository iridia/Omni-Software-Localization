@import <Foundation/CPObject.j>

@import "../Views/OLSidebarOutlineView.j"

var OLSidebarProjectsKey = @"Projects";
var OLSidebarGlossariesKey = @"Glossaries";
var OLSidebarCommunityKey = @"Community";

@implementation OLSidebarController : CPObject
{
    CPDictionary            items;
    OLSidebarOutlineView    sidebarOutlineView;
    
    @outlet                 CPScrollView                sidebarScrollView;
}

- (void)awakeFromCib
{
    items = [CPDictionary dictionary];
    
    // Want projects to initially show up, even if there are no projects.
    [self updateProjects:[CPArray array]];
	[self updateGlossaries:[CPArray array]];
	[self updateCommunity:["Inbox"]];
    
    // Autohide the scrollers here and not in the Cib because it is impossible to
    // select the scrollView in Atlas again otherwise.
    [sidebarScrollView setAutohidesScrollers:YES];
    [sidebarScrollView setHasHorizontalScroller:NO];
    
    sidebarOutlineView = [[OLSidebarOutlineView alloc] initWithFrame:[sidebarScrollView bounds]];
    [sidebarOutlineView setDataSource:self];
    [sidebarOutlineView setDelegate:self];

    [sidebarScrollView setDocumentView:sidebarOutlineView];
}

- (void)updateGlossaries:(CPArray)glossaries
{
	[items setObject:glossaries forKey:OLSidebarGlossariesKey];
	[sidebarOutlineView expandItem:OLSidebarGlossariesKey];
}

- (void)updateProjects:(CPArray)projects
{
    [items setObject:projects forKey:OLSidebarProjectsKey];
    [sidebarOutlineView expandItem:OLSidebarProjectsKey];
}

-(void)updateCommunity:(CPArray)community
{
    [items setObject:community forKey:OLSidebarCommunityKey];
    [sidebarOutlineView expandItem:OLSidebarCommunityKey];
}

@end

@implementation OLSidebarController (OLResourceBundleControllerKVO)

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
    switch (keyPath)
    {
        case @"glossaries":
            [self updateGlossaries:[object glossaries]];
            break;
        case @"projects":
            [self updateProjects:[object projects]];
            break;
        case @"community":
            [self updateCommunity:[object community]];
            break;
        default:
            CPLog.warn(@"%s: Unhandled keypath: %s, in: %s", _cmd, keyPath, [self className]);
            break;
    }
    
    [sidebarOutlineView reloadData];
}

@end

@implementation OLSidebarController (CPOutlineViewDataSource)

- (id)outlineView:(CPOutlineView)outlineView child:(int)index ofItem:(id)item
{
    if (item === nil)
    {
        var keys = [items allKeys];
        return [keys objectAtIndex:index];
    }
    else
    {
        var values = [items objectForKey:item];
        return [values objectAtIndex:index];
    }
}

- (BOOL)outlineView:(CPOutlineView)outlineView isItemExpandable:(id)item
{
    var values = [items objectForKey:item];
    
    var isItemExpandable = ([values count] > 0);
    
    return isItemExpandable;
}

- (int)outlineView:(CPOutlineView)outlineView numberOfChildrenOfItem:(id)item
{
    if (item === nil)
    {
        return [items count];
    }
    else
    {
        var values = [items objectForKey:item];
        return [values count];
    }
}

- (id)outlineView:(CPOutlineView)outlineView objectValueForTableColumn:(CPTableColumn)tableColumn byItem:(id)item
{
    if ([item isKindOfClass:[OLProject class]] || [item isKindOfClass:[OLGlossary class]])
    {
        return [item name];
    }
    else
    {
        return item;  
    }
}

@end
