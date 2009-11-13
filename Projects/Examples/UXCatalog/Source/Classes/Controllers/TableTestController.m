
#import "TableTestController.h"

@interface TableTestDataSource : UXListDataSource {
	NSMutableArray *delegates;
	BOOL isLoading;
	BOOL isLoaded;
}

	-(void) purge;
	-(void) loadForever;
	-(void) fill;
	-(void) fail;

@end

#pragma mark -

@implementation TableTestDataSource

	-(void) purge {
		UXLOG(@"purge");
		isLoading	= NO;
		isLoaded	= YES;
		[self.items removeAllObjects];
	}
	-(void) loadForever {
		UXLOG(@"loadForever");
		isLoading	= YES;
		isLoaded	= NO;
	}
	-(void) fill {
		UXLOG(@"fill");
		isLoading	= NO;
		isLoaded	= YES;
		self.items	= [NSMutableArray arrayWithObjects:
					  [UXTableTextItem itemWithText:@"Pomegranate"],
					  [UXTableTextItem itemWithText:@"Kale"],
					  [UXTableTextItem itemWithText:@"Blueberries"],
					  [UXTableTextItem itemWithText:@"Tomato"],
					  [UXTableTextItem itemWithText:@"Tempeh"],
					  [UXTableTextItem itemWithText:@"Grapefruit"],
					  nil];
	}
	-(void) fail {
		UXLOG(@"fail");
		isLoading	= NO;
		isLoaded	= NO;
		[self.items removeAllObjects];
		[delegates perform:@selector(model:didFailLoadWithError:)
				withObject:self
				withObject:[NSError errorWithDomain:@"foo" code:42 userInfo:nil]];
	}

	#pragma mark UXModel

	-(NSMutableArray *) delegates {
		if (!delegates) {
			delegates = [[NSMutableArray alloc] init];
		}
		return delegates;
	}

	-(BOOL) isLoaded {
		return isLoaded;
	}

	-(BOOL) isLoading {
		return isLoading;
	}

	#pragma mark UXTableViewDataSource

	-(UIImage *) imageForEmpty {
		return UXIMAGE(@"bundle://UXKit.bundle/Images/Placeholders/empty.png");
	}

	-(NSString *) titleForEmpty {
		return NSLocalizedString(@"Empty", @"");
	}

	-(NSString *) subtitleForEmpty {
		return NSLocalizedString(@"There are no items in the datasource.", @"");
	}

	-(UIImage *) imageForError:(NSError *)error {
		return UXIMAGE(@"bundle://UXKit.bundle/Images/Placeholders/error.png");
	}

	-(NSString *) subtitleForError:(NSError *)error {
		return NSLocalizedString(@"An error occurred while loading the datasource.", @"");
	}

	-(void) dealloc {
		[delegates release];
		[super dealloc];
	}

@end

#pragma mark -

@implementation TableTestController

	-(TableTestDataSource *) ds {
		return (TableTestDataSource *)self.dataSource;
	}

	-(void) cycleModelState {
		static int count	= 0;
		self.modelError		= nil;
		
		count == 0 ? [[self ds] loadForever] :
		count == 1 ? [[self ds] fill] :
		count == 2 ? [[self ds] fail] :
		count == 3 ? [[self ds] purge] : NULL;
		
		[self invalidateView];
		if (self.modelError) {
			[self showError:TRUE];
		}
		count = (count + 1) % 4;
	}

	#pragma mark UIViewController

	-(void) loadView {
		[super loadView];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Next" 
																				   style:UIBarButtonItemStyleBordered 
																				  target:self
																				  action:@selector(cycleModelState)] autorelease];
	}

	#pragma mark UXModelViewController

	-(void) createModel {
		self.dataSource = [TableTestDataSource dataSourceWithItems:nil];
	}

@end
