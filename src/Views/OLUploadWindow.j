@import <Foundation/CPObject.j>

var uploadURL = @"Upload/upload.php";

@implementation OLUploadWindow : CPWindow
{
    
}

- (id)initWithContentRect:(CGRect)rect styleMask:(unsigned)styleMask
{
    self = [super initWithContentRect:rect styleMask:styleMask];

    var uploadContentView = [self contentView];
    var bounds = [uploadContentView bounds];

    var newProjectButton = [[UploadButton alloc] initWithFrame:CGRectMake(0, 0, 360, 70)];
    var newProjectButtonImage = [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/big-button.png"];
    var newProjectButtonImagePressed = [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/big-button-pressed.png"];
    [newProjectButton setImage:newProjectButtonImage];
    [newProjectButton setBordered:NO];
    [newProjectButton setAlternateImage:newProjectButtonImagePressed];
    [newProjectButton setDelegate:self];
    [newProjectButton setURL:uploadURL];
    [newProjectButton setFrameOrigin:CGPointMake(12, 12)];

    var projectLabel = [CPTextField labelWithTitle:@"New Project..."];
    [projectLabel setFont:[CPFont boldSystemFontOfSize:14.0]];
    [projectLabel sizeToFit];
    [projectLabel setCenter:CGPointMake([newProjectButton center].x, 32)];

    var projectDescriptionLabel = [CPTextField labelWithTitle:@"Create a new project by uploading a Mac OS X .app bundle"];
    [projectDescriptionLabel setFont:[CPFont boldSystemFontOfSize:12.0]];
    [projectDescriptionLabel setTextColor:[CPColor grayColor]];
    [projectDescriptionLabel sizeToFit];
    [projectDescriptionLabel setCenter:CGPointMake([newProjectButton center].x, 52)];

    var newGlossaryButton = [[UploadButton alloc] initWithFrame:CGRectMake(0, 0, 360, 70)];
    var newGlossaryButtonImage = [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/big-button.png"];
    var newGlossaryButtonImagePressed = [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/big-button-pressed.png"];
    [newGlossaryButton setImage:newGlossaryButtonImage];
    [newGlossaryButton setBordered:NO];
    [newGlossaryButton setAlternateImage:newGlossaryButtonImagePressed];
    [newGlossaryButton setDelegate:self];
    [newGlossaryButton setURL:uploadURL];
    [newGlossaryButton setFrameOrigin:CGPointMake(12, 94)];

    var glossaryLabel = [CPTextField labelWithTitle:@"New Glossary..."];
    [glossaryLabel setFont:[CPFont boldSystemFontOfSize:14.0]];
    [glossaryLabel sizeToFit];
    [glossaryLabel setCenter:CGPointMake([newGlossaryButton center].x, 114)];

    var glossaryDescriptionLabel = [CPTextField labelWithTitle:@"Create a glossary by uploading a .strings file"];
    [glossaryDescriptionLabel setFont:[CPFont boldSystemFontOfSize:12.0]];
    [glossaryDescriptionLabel setTextColor:[CPColor grayColor]];
    [glossaryDescriptionLabel sizeToFit];
    [glossaryDescriptionLabel setCenter:CGPointMake([newGlossaryButton center].x, 134)];

    [uploadContentView addSubview:newProjectButton];
    [uploadContentView addSubview:newGlossaryButton];
    [uploadContentView addSubview:projectLabel];
    [uploadContentView addSubview:projectDescriptionLabel];
    [uploadContentView addSubview:glossaryLabel];
    [uploadContentView addSubview:glossaryDescriptionLabel];
    
    return self;
}

@end