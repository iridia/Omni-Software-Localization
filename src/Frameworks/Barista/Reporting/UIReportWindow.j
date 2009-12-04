
@implementation UIReportWindow : CPWindow
{
	CPArray scripts;
}

- (id)initWithScripts:(CPArray)someScripts
{
	var width = 300;
	var height = 200;
	if(self = [super initWithContentRect:CGRectMake(0, 0, width, height) styleMask:CPTitledWindowMask|CPClosableWindowMask])
	{
		scripts = someScripts;
		var contentView = [self contentView];
		[self setTitle:@"Barista Test Results"];
		
		var success = [CPTextField labelWithTitle:"Successes: " + [self successCount]];
		var fail = [CPTextField labelWithTitle:"Errors:  " + [self failureCount]];
		[success setTextColor:[CPColor colorWithHexString:@"006400"]];
		[fail setTextColor:[CPColor redColor]];
		
		var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0,0,width,height-30)];
		[scrollView setAutohidesScrollers:YES];
		[scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		
		var item = [[CPCollectionViewItem alloc] init];
		[item setView:[[ResultView alloc] initWithFrame:CGRectMake(0,0,width-20,40)]];

		var aCollectionView = [[CPCollectionView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth([scrollView bounds])-20, CGRectGetHeight([scrollView bounds]))];
		[aCollectionView setItemPrototype:item];
		[aCollectionView setMaxNumberOfColumns:1];
		[aCollectionView setVerticalMargin:0.0];
		[aCollectionView setMinItemSize:CPSizeMake(400,40)];
		[aCollectionView setMaxItemSize:CPSizeMake(400,-1)];
		[aCollectionView setContent:scripts];
		[scrollView setBackgroundColor:[CPColor whiteColor]];
		
		[scrollView setDocumentView:aCollectionView];

		[success setCenter:CGPointMake(width/3, height-15)];
		[fail setCenter:CGPointMake(width*2/3, height-15)];

		[contentView addSubview:success];
		[contentView addSubview:fail];
		[contentView addSubview:scrollView];
		[self center];

		[self orderFront:[CPApp delegate]];
	}
	return self;
}

- (CPNumber)successCount
{
	var count = 0;
	for(var i = 0; i < [scripts count]; i++)
	{
		count = count + [[[scripts objectAtIndex:i] successes] count];
	}
	return count;
}

- (CPNumber)failureCount
{
	var count = 0;
	for(var i = 0; i < [scripts count]; i++)
	{
		count = count + [[[scripts objectAtIndex:i] errors] count];
	}
	return count;
}

@end

@implementation ResultView : CPView
{
	CPTextField label;
	CPImageView imageView;
	CPImage goodImage;
	CPImage badImage;
	CPTextField errorsLabel;
	CPImage infoImage;
	CPImageView infoImageView;
}

- (void)setRepresentedObject:(JSObject)anObject
{
	if (!label)
	{
		label = [[CPTextField alloc] initWithFrame:CGRectMake(100, 4, 100, 20)];
		imageView = [[CPImageView alloc] initWithFrame:CGRectMake(60, 4, 32, 32)];
		infoImageView = [[CPImageView alloc] initWithFrame:CGRectMake(308, 4, 32, 32)];
		errorsLabel = [[CPTextField alloc] initWithFrame:CGRectMake(100, 20, 200, 20)];
		
		goodImage = [[CPImage alloc] initWithContentsOfFile:@"Frameworks/Barista/Reporting/Resources/add_32.png"];
		badImage = [[CPImage alloc] initWithContentsOfFile:@"Frameworks/Barista/Reporting/Resources/warning_32.png"];
		infoImage = [[CPImage alloc] initWithContentsOfFile:@"Frameworks/Barista/Reporting/Resources/info_button_32.png"];
		
		[label setFont:[CPFont systemFontOfSize:10.0]];
		
		[errorsLabel setFont:[CPFont systemFontOfSize:12.0]];
		[errorsLabel setTextShadowColor:[CPColor blackColor]];
		[errorsLabel setTextShadowOffset:CGSizeMake(0, 1)];
		[errorsLabel setLineBreakMode:CPLineBreakByWordWrapping];
		[errorsLabel setValue:CGSizeMake(200, -1) forThemeAttribute:@"max-size"];
 
		[self addSubview:label];
		[self addSubview:errorsLabel];
		[self addSubview:imageView];
		[self addSubview:infoImageView];
	}

	[label setStringValue:[anObject filename]];
	[label sizeToFit];
	
	if([[anObject errors] count] == 0)
	{
		[imageView setImage:goodImage];
		[infoImageView setImage:nil];
		[errorsLabel setStringValue:"Errors: None"];
	}
	else
	{
		[imageView setImage:badImage];
		[infoImageView setImage:infoImage];
		var errorsString = "Errors: ";
		var lastOne = [[anObject errors] lastObject];
		for(var i = 0; i < [[anObject errors] count]; i++)
		{
			var theError = [[anObject errors] objectAtIndex:i];
			errorsString = errorsString + theError;
			if(theError != lastOne)
			{
				errorsString = errorsString + ", ";
			}
		}
		
		[errorsLabel setStringValue:errorsString];
		[errorsLabel setFrame:CGRectMake(100, 20, 200, errorsString.length/25*18)];
	}
	
	[self setFrame:CGRectMake(0,0,[self bounds].x, 20+CGRectGetHeight([errorsLabel bounds]))];
	[self setNeedsDisplay:YES];
}

- (void)setSelected:(id)sender
{
	var errorsString = [errorsLabel stringValue];
	if(!errorsString || errorsString == "Errors: None" || errorsString == "")
	{
		return;
	}
	
	var anotherWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(100, 100, 200, 100) 
		styleMask:CPTitledWindowMask|CPClosableWindowMask];
	var contentView = [anotherWindow contentView];
	[anotherWindow setTitle:@"More Information"];
	
	var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0,0,200,400)];
	[scrollView setAutohidesScrollers:YES];
	[scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
	
	var anErrorsLabel = [[CPTextField alloc] initWithFrame:CGRectMake(100, 20, 200, 20)];
	
	[anErrorsLabel setFont:[CPFont systemFontOfSize:12.0]];
	[anErrorsLabel setTextShadowColor:[CPColor blackColor]];
	[anErrorsLabel setTextShadowOffset:CGSizeMake(0, 1)];
	[anErrorsLabel setLineBreakMode:CPLineBreakByWordWrapping];
	[anErrorsLabel setValue:CGSizeMake(200, -1) forThemeAttribute:@"max-size"];
	[anErrorsLabel setStringValue:errorsString];
	[anErrorsLabel setFrame:CGRectMake(0, 0, 200, errorsString.length/40*18)];
	
	[scrollView addSubview:anErrorsLabel];
	
	[contentView addSubview:scrollView];
	
	[anotherWindow orderFront:self];
}

@end