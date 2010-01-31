@import "OLProjectController.j"

@implementation OLMyProjectController : OLProjectController
{
	OLImportProjectController   importProjectController;
}

- (id)init
{
    if(self = [super init])
    {
        projectView = [[OLProjectView alloc] initWithFrame:OSL_MAIN_VIEW_FRAME];
        [projectView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        
        importProjectController = [[OLImportProjectController alloc] init];
   		
        [projectView setResourcesTableViewDataSource:self];
        [projectView setLineItemsTableViewDataSource:self];
        [projectView setResourcesTableViewDelegate:self];
        [projectView setLineItemsTableViewDelegate:self];
        [projectView setLineItemsTarget:self doubleAction:@selector(lineItemsTableViewDoubleClick:)];
        [projectView setResourceBundleDelegate:self];
        [projectView setVotingDataSource:self];
        [projectView setVotingDelegate:self];
        [projectView setOwnerDataSource:self];
        [projectView setTitleDataSource:self];
    }
    return self;
}

@end
