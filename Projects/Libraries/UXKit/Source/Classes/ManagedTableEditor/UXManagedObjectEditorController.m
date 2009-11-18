
#import <UXKit/UXManagedObjectEditorController.h>

@implementation UXManagedObjectEditorController

	@synthesize object;
	@synthesize keyPath;

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
	
	
	// This will be a replaced by either a data source (or UXController subclass of UXArrayController or UXObjectController.
	
	#pragma mark <UITableViewDataSource>

	-(NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
		return 0;
	}

	/*!
	@abstract Row display. Implementers should *always* try to reuse cells by setting each cell's 
	reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
	Cell gets various attributes set automatically based on table (separators) and data source 
	(accessory views, editing controls)
	*/
	-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
		return nil;
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
		[keyPath release]; keyPath = nil;
		[object release]; object = nil;
		[super dealloc];
	}

@end
