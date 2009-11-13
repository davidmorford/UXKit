
#import "ContentController.h"

@implementation ContentController

	@synthesize content = _content;
	@synthesize text	= _text;

	#pragma mark Internal

	-(void) dismiss {
		[self dismissModalViewControllerAnimated:YES];
	}

	-(void) orderAction:(NSString *)action {
		UXLOG(@"ACTION: %@", action);
	}

	-(void) showNutrition {
		UXOpenURL([NSString stringWithFormat:@"uxnavigator://food/%@/nutrition", self.content]);
	}


	#pragma mark Initializer

	-(id) initWithWaitress:(NSString *)waitress query:(NSDictionary *)query {
		if (self = [super init]) {
			_contentType	= ContentTypeOrder;
			self.content	= waitress;
			self.text		= [NSString stringWithFormat:@"Hi, I'm %@, your imaginary waitress.", waitress];
			
			self.title		= @"Place Your Order";
			self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Order" 
																					   style:UIBarButtonItemStyleDone
																					  target:@"uxnavigator://order/confirm" 
																					  action:@selector(openURL)] autorelease];
			self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" 
																					  style:UIBarButtonItemStyleBordered
																					 target:self 
																					 action:@selector(dismiss)] autorelease];
			NSString *ref = [query objectForKey:@"ref"];
			UXLOG(@"ORDER REFERRED FROM %@", ref);
		}
		return self;
	}

	-(id) initWithFood:(NSString *)food {
		if (self = [super init]) {
			_contentType	= ContentTypeFood;
			self.content	= food;
			self.text		= [NSString stringWithFormat:@"<b>%@</b> is just food, ya know?", food];
			self.title		= food;
			self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Nutrition" 
																					   style:UIBarButtonItemStyleBordered 
																					  target:self 
																					  action:@selector(showNutrition)] autorelease];
		}
		return self;
	}

	-(id) initWithNutrition:(NSString *)food {
		if (self = [super init]) {
			_contentType	= ContentTypeNutrition;
			self.content	= food;
			self.text		= [NSString stringWithFormat:@"<b>%@</b> is healthy.  Trust us.", food];
			self.title		= @"Nutritional Info";
		}
		return self;
	}

	-(id) initWithAbout:(NSString *)about {
		if (self = [super init]) {
			_contentType	= ContentTypeNutrition;
			self.content	= about;
			self.text		= [NSString stringWithFormat:@"<b>%@</b> is the name of this page.  Exciting.", about];
			
			if ([about isEqualToString:@"story"]) {
				self.title = @"Our Story";
			}
			else if ([about isEqualToString:@"complaints"]) {
				self.title = @"Complaints Dept.";
			}
		}
		return self;
	}


	#pragma mark <NSObject>

	-(id) init {
		if (self = [super init]) {
			_contentType	= ContentTypeNone;
			_content		= nil;
			_text			= nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_content);
		UX_SAFE_RELEASE(_text);
		[super dealloc];
	}


	#pragma mark @UIViewController

	-(void) loadView {
		[super loadView];
		
		CGRect frame				= CGRectMake(10, 10, self.view.width - 20, 100);
		UXStyledTextLabel *label	= [[[UXStyledTextLabel alloc] initWithFrame:frame] autorelease];
		label.tag					= 42;
		label.font					= [UIFont systemFontOfSize:22];
		[self.view addSubview:label];
		
		if (_contentType == ContentTypeNutrition) {
			self.view.backgroundColor		= [UIColor grayColor];
			label.backgroundColor			= self.view.backgroundColor;
			self.hidesBottomBarWhenPushed	= YES;
		}
		else if (_contentType == ContentTypeOrder) {
		
			UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			
			[button setTitle:@"What do you want to eat?" forState:UIControlStateNormal];
			[button addTarget:@"uxnavigator://order/food"	action:@selector(openURLFromButton:) forControlEvents:UIControlEventTouchUpInside];
			[button sizeToFit];
			
			button.top	= label.bottom + 20;
			button.left = floor(self.view.width / 2 - button.width / 2);

			[self.view addSubview:button];
		}
	}

	-(void) viewWillAppear:(BOOL)animated {
		UXStyledTextLabel *label = (UXStyledTextLabel *)[self.view viewWithTag:42];
		label.html = _text;
	}

@end
