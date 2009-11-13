
#import "LauncherViewTestController.h"

@implementation LauncherViewTestController

	-(id) init {
		if (self = [super init]) {
			self.title = @"Launcher";
		}
		return self;
	}

	-(void) dealloc {
		[launcherView release];
		[super dealloc];
	}

	#pragma mark UIViewController

	-(void) loadView {
		[super loadView];
		launcherView					= [[UXLauncherView alloc] initWithFrame:self.view.bounds];
		launcherView.backgroundColor	= [UIColor blackColor];
		launcherView.delegate			= self;
		launcherView.columnCount		= 4;
		launcherView.pages				= [NSArray arrayWithObjects:
							   [NSArray arrayWithObjects:
								[[[UXLauncherItem alloc] initWithTitle:@"Files"
																 image:@"bundle://UXCatalog.png"
																   URL:nil 
															 canDelete:YES] autorelease],
								
								[[[UXLauncherItem alloc] initWithTitle:@"Messages"
																 image:@"bundle://UXEnvelope.png"
																   URL:@"uxcatalog://item3" 
															 canDelete:YES] autorelease],
								
								[[[UXLauncherItem alloc] initWithTitle:@"Euchere"
																 image:@"bundle://UXGame.png"
																   URL:@"uxcatalog://item4" 
															 canDelete:YES] autorelease],
								
								[[[UXLauncherItem alloc] initWithTitle:@"Movies"
																 image:@"bundle://UXMovie.png"
																   URL:nil 
															 canDelete:YES] autorelease],
								
								[[[UXLauncherItem alloc] initWithTitle:@"Newspaper"
																 image:@"bundle://UXNewspaper.png"
																   URL:nil 
															 canDelete:YES] autorelease],

								[[[UXLauncherItem alloc] initWithTitle:@"Store"
																 image:@"bundle://UXStore.png"
																   URL:nil 
															 canDelete:YES] autorelease], 
								nil],
								[NSArray arrayWithObjects:
								[[[UXLauncherItem alloc] initWithTitle:@"Radio"
																 image:@"bundle://UXRadio.png"
																   URL:nil 
															 canDelete:YES] autorelease],
								[[[UXLauncherItem alloc] initWithTitle:@"Recorder"
																 image:@"bundle://UXRecorder.png"
																   URL:nil 
															 canDelete:YES] autorelease], nil], 
								nil];
		[self.view addSubview:launcherView];
		UXLauncherItem *item	= [launcherView itemWithURL:@"uxcatalog://item3"];
		item.badgeNumber		= 4;
	}

	#pragma mark UXLauncherViewDelegate

	-(void) launcherView:(UXLauncherView *)launcher didSelectItem:(UXLauncherItem *)item {
		
	}

	-(void) launcherViewDidBeginEditing:(UXLauncherView *)launcher {
		[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:launcherView action:@selector(endEditing)] autorelease] 
										  animated:TRUE];
	}

	-(void) launcherViewDidEndEditing:(UXLauncherView *)launcher {
		[self.navigationItem setRightBarButtonItem:nil 
										  animated:TRUE];
	}

@end
