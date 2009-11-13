
#import "TextBarTestController.h"

@interface TextBarStyleSheet : UXDefaultStyleSheet
	-(UXStyle *) chatReloadEmbossedButton:(UIControlState)state;
	-(UXStyle *) rightSpeechBubble;
	-(UXStyle *) leftSpeechBubble;
@end

@implementation TextBarStyleSheet

	-(UXStyle *) rightSpeechBubble {
		return [UXShapeStyle styleWithShape:[UXSpeechBubbleShape shapeWithRadius:5 pointLocation:60 pointAngle:90 pointSize:CGSizeMake(20, 10)] 
									   next:[UXLinearGradientFillStyle styleWithColor1:RGBCOLOR(237, 239, 241) color2:RGBCOLOR(206, 208, 212) 
									   next:[UXSolidBorderStyle styleWithColor:RGBCOLOR(0, 0, 0) width:1 
									   next:nil]]];
	}
	
	-(UXStyle *) leftSpeechBubble {
		return [UXShapeStyle styleWithShape:[UXSpeechBubbleShape shapeWithRadius:5 pointLocation:290 pointAngle:270 pointSize:CGSizeMake(20, 10)] 
									   next:[UXLinearGradientFillStyle styleWithColor1:RGBCOLOR(237, 239, 241) color2:RGBCOLOR(206, 208, 212) 
									   next:[UXSolidBorderStyle styleWithColor:RGBCOLOR(0, 0, 0) width:1 
									   next:[UXTextStyle styleWithFont:nil color:[UIColor blackColor] shadowColor:[UIColor colorWithWhite:255 alpha:0.4] shadowOffset:CGSizeMake(0, -1) 
									   next:nil]]]];
	}

	-(UXStyle *) chatReloadEmbossedButton:(UIControlState)state {
		if (state == UIControlStateNormal) {
			return [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:8] 
										   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(0, 0, 1, 0) 
										   next:[UXShadowStyle styleWithColor:RGBACOLOR(255, 255, 255, 0) blur:1 offset:CGSizeMake(0, 1) 
										   next:[UXLinearGradientFillStyle styleWithColor1:RGBCOLOR(255, 255, 255) color2:RGBCOLOR(216, 221, 231) 
										   next:[UXSolidBorderStyle styleWithColor:RGBCOLOR(161, 167, 178) width:1 
										   next:[UXBoxStyle styleWithPadding:UIEdgeInsetsMake(10, 12, 9, 12) 
										   next:[UXTextStyle styleWithFont:nil color:UXSTYLEVAR(linkTextColor) shadowColor:[UIColor colorWithWhite:255 alpha:0.4] shadowOffset:CGSizeMake(0, -1) 
										   next:nil]]]]]]];
		}
		else if (state == UIControlStateHighlighted)  {
			return [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:8] 
										   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(0, 0, 1, 0) 
										   next:[UXShadowStyle styleWithColor:RGBACOLOR(255, 255, 255, 0.9) blur:1 offset:CGSizeMake(0, 1) 
										   next:[UXLinearGradientFillStyle styleWithColor1:RGBCOLOR(225, 225, 225) color2:RGBCOLOR(196, 201, 221) 
										   next:[UXSolidBorderStyle styleWithColor:RGBCOLOR(161, 167, 178) width:1 
										   next:[UXBoxStyle styleWithPadding:UIEdgeInsetsMake(10, 12, 9, 12) 
										   next:[UXTextStyle styleWithFont:nil color:[UIColor whiteColor] shadowColor:[UIColor colorWithWhite:255 alpha:0.4] shadowOffset:CGSizeMake(0, -1) 
										   next:nil]]]]]]];
		}
		else {
			return nil;
		}
	}

	/*	
	-(UXStyle *) blueBox {
		return [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:6] 
									   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(0, -5, -4, -6) 
									   next:[UXShadowStyle styleWithColor:[UIColor grayColor] blur:2 offset:CGSizeMake(1, 1) 
									   next:[UXSolidFillStyle styleWithColor:[UIColor colorWithHue:(210.0f / 360.0f)saturation:(50.0f / 100.0f)brightness:(100.0f / 100.0f)alpha:(100.0f / 100.0f)] 
									   next:[UXSolidBorderStyle styleWithColor:[UIColor grayColor] width:1 
									   next:nil]]]]];
	}
	-(UXStyle *) highlightBox {
		return [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:4] 
									   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(2, -5, -2, -5) 
									   next:[UXShadowStyle styleWithColor:[UIColor grayColor] blur:2 offset:CGSizeMake(1, 1) 
									   next:[UXSolidFillStyle styleWithColor:[UIColor colorWithHue:(45.0f / 360.0f)saturation:(50.0f / 100.0f)brightness:(100.0f / 100.0f)alpha:(100.0f / 100.0f)] 
									   next:[UXSolidBorderStyle styleWithColor:[UIColor colorWithHue:(45.0f / 360.0f)saturation:(25.0f / 100.0f)brightness:(100.0f / 100.0f)alpha:(100.0f / 100.0f)] width:0.5 
									   next:nil]]]]];
	}
	*/

@end

#pragma mark -

@interface TextBarTestController ()

	-(void) displayTextBar;
	-(void) layout;

@end

#pragma mark -

@implementation TextBarTestController

	@synthesize chatMessages;
	@synthesize textBarController;

	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			self.chatMessages = [[NSMutableArray alloc] init];
			[UXStyleSheet setGlobalStyleSheet:[[[TextBarStyleSheet alloc] init] autorelease]];
		}
		return self;
	}

	-(void) displayTextBar {
		if (!self.textBarController) {
			self.textBarController = [[UXTextBarController alloc] init];
			self.textBarController.delegate = self;
		}
		[self.textBarController showInView:self.view animated:TRUE];
	}


	#pragma mark UIViewController

	-(void) loadView {
		[super loadView];
		self.view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
		UIBarButtonItem *composeButton	= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose 
																					    target:self
																					    action:@selector(displayTextBar)];
		self.navigationItem.rightBarButtonItem = composeButton;
		[composeButton release];

		scrollView = [[UIScrollView alloc] initWithFrame:UXNavigationFrame()];
		scrollView.autoresizesSubviews      = YES;
		scrollView.autoresizingMask         = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		scrollView.backgroundColor          = RGBCOLOR(137, 157, 169); // 214 19 66
		scrollView.canCancelContentTouches  = NO;
		scrollView.delaysContentTouches     = NO;
		scrollView.contentSize				= CGSizeMake(320, 10);
		self.view = scrollView;
	}

	#pragma mark Model

	-(void) insertMessageWithText:(NSString *)chatText {
		[self.chatMessages addObject:chatText];
		CGFloat viewHeight = 10;
		for (UIView *subview in scrollView.subviews) {
			if ([subview isKindOfClass:[UXView class]]) {
				viewHeight += (subview.height + 10);
			}
		}
		
		CGRect frame			= CGRectMake(20, viewHeight, 280, 84);
		UXLabel *view			= [[[UXLabel alloc] initWithFrame:frame] autorelease];
		view.backgroundColor	= scrollView.backgroundColor;
		view.text				= chatText;
		view.style				= UXSTYLEVAR(leftSpeechBubble);
		[scrollView addSubview:view];
		
		scrollView.contentSize = CGSizeMake(scrollView.width, (scrollView.contentSize.height + (view.frame.size.height + 10)));
		
		if (scrollView.contentSize.height > scrollView.frame.size.height) {
			CGFloat scrollYPoint = scrollView.contentSize.height - scrollView.frame.size.height;
			UXLOG(@"Scroll to Y point : %f", scrollYPoint);
			[scrollView scrollRectToVisible:CGRectMake(0, scrollYPoint, scrollView.frame.size.width, scrollView.frame.size.height)
								   animated:TRUE];
			[scrollView flashScrollIndicators];
		}
	}


	#pragma mark UXLayout

	-(void) layout {
		UXFlowLayout *flowLayout	= [[[UXFlowLayout alloc] init] autorelease];
		flowLayout.padding			= 10;
		flowLayout.spacing			= 10;
		CGSize size					= [flowLayout layoutSubviews:scrollView.subviews forView:scrollView];
		scrollView.contentSize		= CGSizeMake(scrollView.width, size.height);
	}


	#pragma mark <UXTextBarDelegate>

	-(void) textBarDidBeginEditing:(UXTextBarController *)controller {
		UXLOGMETHOD;
	}

	-(void) textBarDidEndEditing:(UXTextBarController *)controller {
		UXLOGMETHOD;
	}

	-(BOOL) textBar:(UXTextBarController *)textBar willPostText:(NSString *)text {
		UXLOGMETHOD;
		[self.textBarController dismissPopupViewControllerAnimated:TRUE];
		[self performSelector:@selector(insertMessageWithText:) withObject:text afterDelay:1.0];
		return TRUE;
	}

	-(void) textBar:(UXTextBarController *)textBar didPostText:(NSString *)text withResult:(id)result {
		UXLOGMETHOD;
	}

	-(void) textBarDidCancel:(UXTextBarController *)textBar {
		UXLOGMETHOD;
	}

	#pragma mark Destructor

	-(void) dealloc {
		UX_SAFE_RELEASE(chatMessages);
		UX_SAFE_RELEASE(textBarController);
		[super dealloc];
	}

@end
