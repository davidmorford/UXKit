
#import "StyledTextTestViewController.h"

@implementation StyledTextViewControllerStyleSheet

	#pragma mark About Styles

	-(UXStyle *) aboutBackgroundColor {
		return [UXTextStyle styleWithColor:RGBCOLOR(255,255,255) next:nil];
	}

	-(UXStyle *) aboutHeaderTextColor {
		return [UXTextStyle styleWithColor:RGBCOLOR(128,128,128) next:nil];
	}

	-(UXStyle *) aboutLargeText {
		return [UXTextStyle styleWithFont:[UIFont systemFontOfSize:32] next:nil];
	}

	-(UXStyle *) aboutHighlightBox {
		return [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:4] 
									   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(2, -5, -2, -5) 
									   next:[UXShadowStyle styleWithColor:[UIColor grayColor] blur:2 offset:CGSizeMake(1, 1) 
									   next:[UXSolidFillStyle styleWithColor:[UIColor colorWithHue:(45.0f / 360.0f)saturation:(50.0f / 100.0f)brightness:(100.0f / 100.0f)alpha:(100.0f / 100.0f)] 
									   next:[UXSolidBorderStyle styleWithColor:[UIColor colorWithHue:(45.0f / 360.0f)saturation:(25.0f / 100.0f)brightness:(100.0f / 100.0f)alpha:(100.0f / 100.0f)] width:0.5 
									   next:nil]]]]];
	}

	-(UXStyle *) aboutInlineBox {
		return [UXSolidFillStyle styleWithColor:[UIColor blueColor] 
										   next:[UXBoxStyle styleWithPadding:UIEdgeInsetsMake(5, 13, 5, 13) 
										   next:[UXSolidBorderStyle styleWithColor:[UIColor blackColor] width:1 
										   next:nil]]];
	}
	

	#pragma mark TOS Styles

	-(UXStyle *) mediumText {
		return [UXTextStyle styleWithFont:[UIFont systemFontOfSize:17] next:nil];
	}

	-(UXStyle *) smallTOSText {
		return [UXTextStyle styleWithFont:[UIFont systemFontOfSize:15] next:nil];
	}

	-(UXStyle *) smallTOSBoldText {
		return [UXTextStyle styleWithFont:[UIFont boldSystemFontOfSize:15] next:nil];
	}

	-(UXStyle *) largeTOSText {
		return [UXTextStyle styleWithFont:[UIFont boldSystemFontOfSize:24] next:nil];
	}


	-(UXStyle *) floated {
		return [UXBoxStyle styleWithMargin:UIEdgeInsetsMake(0, 0, 5, 5)
								   padding:UIEdgeInsetsMake(0, 0, 0, 0)
								   minSize:CGSizeZero
								  position:UXPositionFloatLeft
									  next:nil];
	}

@end

#pragma mark -

@implementation StyledTextTestViewController

	#pragma mark UIViewController

	-(id) init {
		if (self = [super initWithFile:@"StyledTextViewControllerTest.html"]) {
			[UXStyleSheet setGlobalStyleSheet:[[[StyledTextViewControllerStyleSheet alloc] init] autorelease]];
		}
		return self;
	}

	-(void) loadView {
		[super loadView];
		self.title = @"Style Text";
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
		[UXStyleSheet setGlobalStyleSheet:nil];
		[super dealloc];
	}

@end
