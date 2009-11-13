
#import "YouTubeTestController.h"

@implementation YouTubeTestController

	-(id) init {
		if (self = [super init]) {
			youTubeView = nil;
		}
		return self;
	}


	#pragma mark UIViewController

	-(void) loadView {
		[super loadView];
		self.view					= [[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
		self.view.backgroundColor	= [UIColor colorWithHue:(0/360) saturation:(0/100) brightness:(25/100) alpha:(100/100)];
		
		//http://www.youtube.com/watch?v=g8thp78oXsg
		//http://www.youtube.com/watch?v=R706isyDrqI
		//http://www.youtube.com/watch?v=OYecfV3ubP8
		
		youTubeView					= [[UXYouTubeView alloc] initWithURL:@"http://www.youtube.com/watch?v=OYecfV3ubP8"];
		//youTubeView.center		= CGPointMake(self.view.width / 2, self.view.height / 2);
		youTubeView.frame			= CGRectMake(0, 0, 320, 240);
		youTubeView.backgroundColor	= [UIColor colorWithHue:(0/360) saturation:(0/100) brightness:(25/100) alpha:(100/100)];
		[self.view addSubview:youTubeView];
		
		UILabel *label			= [[UILabel alloc] initWithFrame:CGRectZero];
		label.font				= [UIFont boldSystemFontOfSize:11];
		label.text				= @"For today, we celebrate the first glorious anniversary of the Information Purification Directives. We have created, for the first time in all history, a garden of pure ideology. Where each worker may bloom secure from the pests of contradictory and confusing truths. Our Unification of Thought is more powerful a weapon than any fleet or army on earth. We are one people. With one will. One resolve. One cause. Our enemies shall talk themselves to death. And we will bury them with their own confusion. We shall prevail!";
		label.backgroundColor	= [UIColor colorWithHue:(0/360) saturation:(0/100) brightness:(25/100) alpha:(100/100)];
		label.textColor			= [UIColor whiteColor];
		label.textAlignment		= UITextAlignmentLeft;
		label.numberOfLines		= 0;
		label.backgroundColor   = [UIColor clearColor];
		CGSize stringSize		= [label.text sizeWithFont:label.font forWidth:300 lineBreakMode:UILineBreakModeWordWrap];
		label.frame				= CGRectMake(10, 240, 300, 200);
		UXLOG(@"Directive Text Size = %@", NSStringFromCGSize(stringSize));
		[self.view addSubview:label];
		[label release];
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(youTubeView);
		[super dealloc];
	}

@end
