
#import <UXKit/UXManagedModelViewController.h>

@implementation UXManagedModelViewController

	#pragma mark UIViewController

	-(id) init {
		if (self = [super init]) {
		}
		return self;
	}

	-(void) loadView {
		[super loadView];
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

	-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
		return (interfaceOrientation == UIInterfaceOrientationPortrait);
	}

	-(void) didReceiveMemoryWarning {
		[super didReceiveMemoryWarning];
	}

	#pragma mark Destructor

	-(void) dealloc {
		[super dealloc];
	}

@end
