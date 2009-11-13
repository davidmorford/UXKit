
#import "ActivityTestController.h"

@implementation ActivityTestController

	-(id) init {
		if (self = [super init]) {
			self.title = @"Activity Labels";
		}
		return self;
	}

	-(void) dealloc {
		[super dealloc];
	}

	#pragma mark -

	-(void) addActivityLabelWithStyle:(UXActivityLabelStyle)style progress:(BOOL)progress {
		UXActivityLabel *label		= [[[UXActivityLabel alloc] initWithStyle:style] autorelease];
		UIView *lastView			= [self.view.subviews lastObject];
		label.text					= @"Loading...";
		if (progress) {
			label.progress = 0.3;
		}
		[label sizeToFit];
		label.frame					= CGRectMake(0, lastView.bottom + 10, self.view.width, label.height);
		
		UXLOG(@" Activity Lable Frame RECT = %@", NSStringFromCGRect(label.frame));
		
		[self.view addSubview:label];
	}

	-(void) showLabelsWithProgress:(BOOL)progress {
		UIScrollView *scrollView = (UIScrollView *)self.view;
		[scrollView removeAllSubviews];
		if (progress) {
			self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"No Progress"
																					   style:UIBarButtonItemStyleBordered 
																					   target:self 
																					   action:@selector(hideProgress)] autorelease];
		}
		else {
			self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Progress"
																					   style:UIBarButtonItemStyleBordered 
																					   target:self 
																					   action:@selector(showProgress)] autorelease];
		}
		
		UXSearchlightLabel *label	= [[[UXSearchlightLabel alloc] init] autorelease];
		label.text					= @"Searchlight Label";
		label.font					= [UIFont systemFontOfSize:25];
		label.textAlignment			= UITextAlignmentCenter;
		label.contentMode			= UIViewContentModeCenter;
		label.backgroundColor		= [UIColor blackColor];
		[label sizeToFit];
		label.frame					= CGRectMake(0, 0, self.view.width, label.height + 40);
		[self.view addSubview:label];
		[label startAnimating];
		
		[self addActivityLabelWithStyle:UXActivityLabelStyleWhiteBox progress:progress];
		[self addActivityLabelWithStyle:UXActivityLabelStyleBlackBox progress:progress];
		[self addActivityLabelWithStyle:UXActivityLabelStyleWhiteBezel progress:progress];
		[self addActivityLabelWithStyle:UXActivityLabelStyleBlackBezel progress:progress];
		[self addActivityLabelWithStyle:UXActivityLabelStyleGray progress:progress];
		[self addActivityLabelWithStyle:UXActivityLabelStyleWhite progress:progress];
		[self addActivityLabelWithStyle:UXActivityLabelStyleBlackBanner progress:progress];
		
		UIView *lastView		= [scrollView.subviews lastObject];
		scrollView.contentSize	= CGSizeMake(scrollView.width, lastView.bottom);
	}

	-(void) showProgress {
		[self showLabelsWithProgress:YES];
	}

	-(void) hideProgress {
		[self showLabelsWithProgress:NO];
	}


	#pragma mark @UIViewController

	-(void) loadView {
		UIScrollView *scrollView	= [[[UIScrollView alloc] initWithFrame:UXNavigationFrame()] autorelease];
		scrollView.backgroundColor	= [UIColor groupTableViewBackgroundColor];
		self.view					= scrollView;
		[self showLabelsWithProgress:NO];
	}

@end
