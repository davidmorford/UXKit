
#import <UXKit/UXManagedObjectEditorController.h>

@implementation UXManagedObjectEditorController

	@synthesize object;
	@synthesize keyPath;
	@synthesize label;

	#pragma mark Initializer

	-(id) init {
		self = [super init];
		if (self != nil) {
		}
		return self;
	}

	#pragma mark <UIViewController>

	-(void) loadView {
		[super loadView];
		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"")
																		 style:UIBarButtonSystemItemCancel
																		target:self
																		action:@selector(cancel)];
		self.navigationItem.leftBarButtonItem = cancelButton;
		[cancelButton release];
		UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"")
																	   style:UIBarButtonItemStyleBordered 
																	  target:self
																	  action:@selector(save)];
		self.navigationItem.rightBarButtonItem = saveButton;
		[saveButton release];
	}


	#pragma mark Actions

	-(void) cancel {
		// Reconcile with UXNavigator and UXNavigationController and UXLauncherViewController
		[self.navigationController popViewControllerAnimated:YES];
	}

	-(void) save {
	
	}

	#pragma mark -

	-(void) dealloc {
		[label release]; label = nil;
		[keyPath release]; keyPath = nil;
		[object release]; object = nil;
		[super dealloc];
	}

@end
