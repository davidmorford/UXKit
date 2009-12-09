
#import "___PROJECTNAMEASIDENTIFIER___LaunchNavigator.h"

@implementation ___PROJECTNAMEASIDENTIFIER___LaunchNavigator

	#pragma mark Initializer

	-(id) init {
		if (self = [super init]) {
			self.title = @"___PROJECTNAMEASIDENTIFIER___";
		}
		return self;
	}


	#pragma mark UIViewController

	-(void) loadView {
		[super loadView];
		_launcherView.delegate		= self;
		_launcherView.columnCount	= 4;
		_launcherView.pages = [NSArray arrayWithObjects:[NSArray arrayWithObjects:  
								 [[[UXLauncherItem alloc] initWithTitle:@"Launch Item"
																  image:@"bundle://___PROJECTNAMEASIDENTIFIER___.png"
																	URL:nil 
															  canDelete:YES] autorelease], nil], nil];
	}

	-(void) viewDidLoad {
		[super viewDidLoad];
	}

	-(void) viewWillAppear:(BOOL)animated {
		[super viewWillAppear:animated];
	}

	-(void) viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];
	}

	-(void) viewWillDisappear:(BOOL)animated {
		[super viewWillDisappear:animated];
	}

	-(void) viewDidDisappear:(BOOL)animated {
		[super viewDidDisappear:animated];
	}


	#pragma mark <UXLauncherViewDelegate>

	-(void) launcherView:(UXLauncherView *)launcher didSelectItem:(UXLauncherItem *)item {
		[[UXNavigator navigator] openURL:item.URL animated:YES];
	}

	-(void) launcherViewDidBeginEditing:(UXLauncherView *)launcher {
		[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																								  target:_launcherView 
																								  action:@selector(endEditing)] autorelease] animated:YES];
	}

	-(void) launcherViewDidEndEditing:(UXLauncherView *)launcher {
		[self.navigationItem setRightBarButtonItem:nil animated:YES];
	}


	#pragma mark Memory

	-(void) viewDidUnload {
		[super viewDidUnload];
	}

	-(void) didReceiveMemoryWarning {
		[super didReceiveMemoryWarning];
	}

	-(void) dealloc {
		[super dealloc];
	}

@end
