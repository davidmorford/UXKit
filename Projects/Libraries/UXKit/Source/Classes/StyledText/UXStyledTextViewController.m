
#import <UXKit/UXStyledTextViewController.h>
#import <UXKit/UXStyledText.h>
#import <UXKit/UXStyledTextLabel.h>
#import <UXKit/UXLayout.h>

@interface UXStyledTextViewController ()
	-(void) layout;
@end

#pragma mark -

@implementation UXStyledTextViewController
	
	@synthesize scrollView;
	@synthesize text;
	@synthesize styledText;
	@synthesize styledTextLabel;

	#pragma mark Initializer

	-(id) initWithText:(NSString *)textString {
		self = [super init];
		if (self != nil) {
			self.text = textString;
		}
		return self;
	}

	-(id) initWithFile:(NSString *)filePath {
		if (self = [super init]) {
			self.text = [[NSString alloc] initWithContentsOfFile:UXPathForBundleResource(filePath) 
														encoding:NSUTF8StringEncoding 
														   error:nil];
		}
		return self;
	}

	#pragma mark UIViewController

	-(void) loadView {
		[super loadView];
		self.styledText							= [UXStyledText textFromXHTML:self.text lineBreaks:FALSE URLs:TRUE];
		self.scrollView							= [[UIScrollView alloc] initWithFrame:UXNavigationFrame()];
		self.scrollView.autoresizesSubviews		= YES;
		self.scrollView.autoresizingMask		= (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		self.scrollView.indicatorStyle			= UIScrollViewIndicatorStyleBlack;
		self.scrollView.backgroundColor		=	RGBCOLOR(255, 255, 255);
		self.view = self.scrollView;
		
		self.styledTextLabel = [[[UXStyledTextLabel alloc] initWithFrame:self.view.bounds] autorelease];
		self.styledTextLabel.font				= [UIFont systemFontOfSize:17];
		self.styledTextLabel.text				= [UXStyledText textFromXHTML:self.text];
		self.styledTextLabel.contentInset		= UIEdgeInsetsMake(20, 20, 20, 20);
		self.styledTextLabel.backgroundColor	= RGBCOLOR(255, 255, 255);
		self.styledTextLabel.textColor			= RGBCOLOR(0, 0, 0);
		[self.styledTextLabel sizeToFit];
		[self.view addSubview:self.styledTextLabel];
		
		scrollView.contentSize = CGSizeMake(scrollView.width, self.styledTextLabel.bounds.size.height);
	}
	
	-(void) viewDidUnload {
		[super viewDidUnload];
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
	

	#pragma mark -

	-(void) layout {
		UXFlowLayout *flowLayout	= [[[UXFlowLayout alloc] init] autorelease];
		flowLayout.padding			= 20;
		flowLayout.spacing			= 20;
		CGSize size					= [flowLayout layoutSubviews:self.view.subviews forView:self.view];
		self.scrollView.contentSize		= CGSizeMake(self.scrollView.width, size.height);
	}

	#pragma mark -

	-(void) dealloc {
		[text release]; text = nil;
		[styledText release]; styledText = nil;
		[styledTextLabel release]; styledTextLabel = nil;
		[scrollView release]; scrollView = nil;
		[super dealloc];
	}

@end
