
#import "ButtonTestController.h"

@interface ButtonTestStyleSheet : UXDefaultStyleSheet
@end

@implementation ButtonTestStyleSheet

	-(UXStyle *) blackForwardButton:(UIControlState)state {
		UXShape *shape		= [UXRoundedRightArrowShape shapeWithRadius:4.5];
		UIColor *tintColor	= RGBCOLOR(0, 0, 0);
		return [UXSTYLESHEET toolbarButtonForState:state shape:shape tintColor:tintColor font:nil];
	}

	-(UXStyle *) blueToolbarButton:(UIControlState)state {
		UXShape *shape		= [UXRoundedRectangleShape shapeWithRadius:4.5];
		UIColor *tintColor	= RGBCOLOR(30, 110, 255);
		return [UXSTYLESHEET toolbarButtonForState:state shape:shape tintColor:tintColor font:nil];
	}


	#pragma mark Launch Buttons

	-(UIColor *) insetActionButtonColorWithTintColor:(UIColor *)aColor forState:(UIControlState)aState {
		if (aState & UIControlStateHighlighted || aState & UIControlStateSelected) {
			if (aColor.value < 0.2) {
				return [aColor addHue:0 saturation:0 value:0.2];
			}
			else if (aColor.saturation > 0.3) {
				return [aColor multiplyHue:1 saturation:1 value:0.4];
			}
			else {
				return [aColor multiplyHue:1 saturation:2.3 value:0.64];
			}
		}
		else {
			if (aColor.saturation < 0.5) {
				return [aColor multiplyHue:1 saturation:1.6 value:0.97];
			}
			else {
				return [aColor multiplyHue:1 saturation:1.25 value:0.75];
			}
		}
	}

	-(UXStyle *) insetActionButtonforState:(UIControlState)state tintColor:(UIColor *)tintColor {
		UIColor *buttonTintColor = [self insetActionButtonColorWithTintColor:tintColor forState:state];
		if (state == UIControlStateNormal) {
			return [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:9] 
										   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(1, 0, 1, 0) 
										   next:[UXLinearGradientFillStyle styleWithColor1:RGBACOLOR(110, 110, 110, 1) color2:RGBACOLOR(55, 55, 55, 1) 
										   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(3, 3, 3, 3) 
										   next:[UXReflectiveFillStyle styleWithColor:buttonTintColor  
										   next:[UXBoxStyle styleWithPadding:UIEdgeInsetsMake(9, 12, 10, 12) 
										   next:[UXTextStyle styleWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:17] color:[UIColor whiteColor] shadowColor:[UIColor grayColor] shadowOffset:CGSizeMake(0, -1) 
										   next:nil]]]]]]];
		}
		else if (state == UIControlStateHighlighted)  {
			return [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:9] 
										   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(1, 0, 1, 0) 
										   next:[UXLinearGradientFillStyle styleWithColor1:RGBACOLOR(110, 110, 110, 1) color2:RGBACOLOR(55, 55, 55, 1) 
										   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(3, 3, 3, 3) 
										   next:[UXReflectiveFillStyle styleWithColor:buttonTintColor  
										   next:[UXBoxStyle styleWithPadding:UIEdgeInsetsMake(9, 12, 10, 12) 
										   next:[UXTextStyle styleWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:17] color:[UIColor whiteColor] shadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(0, 0) 
										   next:nil]]]]]]];
		}
		else {
			return nil;
		}
	}


	-(UXStyle *) insetBlackActionButton:(UIControlState)state {
		UIColor *tintColor	= RGBCOLOR(48, 48, 48);
		return [UXSTYLESHEET insetActionButtonforState:state tintColor:tintColor];
	}

	-(UXStyle *) insetRedActionButton:(UIControlState)state {
		UIColor *tintColor	= RGBCOLOR(175, 44, 25);
		return [UXSTYLESHEET insetActionButtonforState:state tintColor:tintColor];
	}

	-(UXStyle *) insetGreenActionButton:(UIControlState)state {
		UIColor *tintColor	= RGBCOLOR(23, 126, 35);
		return [UXSTYLESHEET insetActionButtonforState:state tintColor:tintColor];
	}

	-(UXStyle *) insetDarkBlueActionButton:(UIControlState)state {
		UIColor *tintColor	= RGBCOLOR(0, 32, 128);
		return [UXSTYLESHEET insetActionButtonforState:state tintColor:tintColor];
	}

	-(UXStyle *) insetBlueActionButton:(UIControlState)state {
		UIColor *tintColor	= RGBCOLOR(77, 95, 154);
		return [UXSTYLESHEET insetActionButtonforState:state tintColor:tintColor];
	}


	#pragma mark -

	-(UIColor *) actionButtonColorWithTintColor:(UIColor *)aColor forState:(UIControlState)aState {
		if (aState & UIControlStateHighlighted || aState & UIControlStateSelected) {
			if (aColor.value < 0.2) {
				return [aColor addHue:0 saturation:0 value:0.2];
			}
			else if (aColor.saturation > 0.3) {
				return [aColor multiplyHue:1 saturation:1 value:0.4];
			}
			else {
				return [aColor multiplyHue:1 saturation:2.3 value:0.64];
			}
		}
		else {
			if (aColor.saturation < 0.5) {
				return [aColor multiplyHue:1 saturation:1.6 value:0.97];
			}
			else {
				return [aColor multiplyHue:1 saturation:1.25 value:0.75];
			}
		}
	}

	-(UXStyle *) actionButtonforState:(UIControlState)state tintColor:(UIColor *)tintColor {
		UIColor *buttonTintColor	= [self actionButtonColorWithTintColor:tintColor forState:state];
		UIColor *textColor			= [UIColor colorWithWhite:0.3 alpha:1.0];
		if (state == UIControlStateNormal) {
			return [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:10] 
										   next:[UXLinearGradientFillStyle styleWithColor1:RGBACOLOR(110, 110, 110, 1) color2:RGBACOLOR(55, 55, 55, 1) 
										   next:[UXReflectiveFillStyle styleWithColor:buttonTintColor  
										   next:[UXBoxStyle styleWithPadding:UIEdgeInsetsMake(9, 12, 10, 12) 
										   next:[UXTextStyle styleWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:15] color:textColor shadowColor:nil shadowOffset:CGSizeMake(0, 0) 
										   next:nil]]]]];
		}
		else if (state == UIControlStateHighlighted)  {
			return [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:10] 
										   next:[UXLinearGradientFillStyle styleWithColor1:RGBACOLOR(110, 110, 110, 1) color2:RGBACOLOR(55, 55, 55, 1) 
										   next:[UXReflectiveFillStyle styleWithColor:buttonTintColor  
										   next:[UXBoxStyle styleWithPadding:UIEdgeInsetsMake(9, 12, 10, 12) 
										   next:[UXTextStyle styleWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:15] color:textColor shadowColor:nil shadowOffset:CGSizeMake(0, 0) 
										   next:nil]]]]];
		}
		else {
			return nil;
		}
	}

	-(UXStyle *) whiteActionButton:(UIControlState)state {
		UIColor *tintColor	= RGBCOLOR(250, 250, 250);
		return [UXSTYLESHEET actionButtonforState:state tintColor:tintColor];
	}

	-(UXStyle *) blueActionButton:(UIControlState)state {
		UIColor *tintColor	= RGBCOLOR(64, 128, 242);
		return [UXSTYLESHEET actionButtonforState:state tintColor:tintColor];
	}



	#pragma mark -

	-(UXStyle *) embossedButton:(UIControlState)state {
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

	-(UXStyle *) dropButton:(UIControlState)state {
		if (state == UIControlStateNormal) {
			return [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:8] 
										   next:[UXShadowStyle styleWithColor:RGBACOLOR(0, 0, 0, 0.7) blur:3 offset:CGSizeMake(2, 2) 
										   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(0.25, 0.25, 0.25, 0.25) 
										   next:[UXSolidFillStyle styleWithColor:[UIColor whiteColor] 
										   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(-0.25, -0.25, -0.25, -0.25) 
										   next:[UXSolidBorderStyle styleWithColor:RGBCOLOR(161, 167, 178) width:1 
										   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(2, 0, 0, 0) 
										   next:[UXBoxStyle styleWithPadding:UIEdgeInsetsMake(11, 10, 9, 10) 
										   next:[UXTextStyle styleWithFont:nil color:UXSTYLEVAR(linkTextColor) shadowColor:[UIColor colorWithWhite:255 alpha:0.4] shadowOffset:CGSizeMake(0, -1) 
										   next:nil]]]]]]]]];
		}
		else if (state == UIControlStateHighlighted)  {
			return [UXInsetStyle styleWithInset:UIEdgeInsetsMake(3, 3, 0, 0) 
										   next:[UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:8] 
										   next:[UXSolidFillStyle styleWithColor:[UIColor whiteColor] 
										   next:[UXSolidBorderStyle styleWithColor:RGBCOLOR(161, 167, 178) width:1 
										   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(2, 0, 0, 0) 
										   next:[UXBoxStyle styleWithPadding:UIEdgeInsetsMake(11, 10, 9, 10) 
										   next:[UXTextStyle styleWithFont:nil color:UXSTYLEVAR(linkTextColor) shadowColor:[UIColor colorWithWhite:255 alpha:0.4] shadowOffset:CGSizeMake(0, -1) 
										   next:nil]]]]]]];
		}
		else {
			return nil;
		}
	}

@end

#pragma mark -

@implementation ButtonTestController

	-(void) layout {
		UXFlowLayout *flowLayout	= [[[UXFlowLayout alloc] init] autorelease];
		flowLayout.padding			= 20;
		flowLayout.spacing			= 20;
		CGSize size					= [flowLayout layoutSubviews:self.view.subviews forView:self.view];
		UIScrollView *scrollView	= (UIScrollView *)self.view;
		scrollView.contentSize		= CGSizeMake(scrollView.width, size.height);
	}

	-(void) increaseFont {
		_fontSize += 4;
		for (UIView *view in self.view.subviews) {
			if ([view isKindOfClass:[UXButton class ]]) {
				UXButton *button	= (UXButton *)view;
				button.font			= [UIFont boldSystemFontOfSize:_fontSize];
				[button sizeToFit];
			}
		}
		[self layout];
	}


	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			_fontSize = 12;
			[UXStyleSheet setGlobalStyleSheet:[[[ButtonTestStyleSheet alloc] init] autorelease]];
		}
		return self;
	}

	-(void) dealloc {
		[UXStyleSheet setGlobalStyleSheet:nil];
		[super dealloc];
	}


	#pragma mark UIViewController

	-(void) loadView {
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Increase Font"
																				   style:UIBarButtonItemStyleBordered
																				  target:self
																				  action:@selector(increaseFont)] autorelease];
		
		UIScrollView *scrollView            = [[[UIScrollView alloc] initWithFrame:UXNavigationFrame()] autorelease];
		scrollView.autoresizesSubviews      = YES;
		scrollView.autoresizingMask         = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		scrollView.backgroundColor          = RGBCOLOR(216, 221, 231);
		//scrollView.backgroundColor		= RGBCOLOR(119, 140, 168);
		scrollView.canCancelContentTouches  = NO;
		scrollView.delaysContentTouches     = NO;
		self.view                           = scrollView;
		
		NSArray *buttons = [NSArray arrayWithObjects:
							[UXButton buttonWithStyle:@"toolbarButton:" title:@"Toolbar Button"],
							[UXButton buttonWithStyle:@"toolbarRoundButton:" title:@"Round Button"],
							[UXButton buttonWithStyle:@"toolbarBackButton:" title:@"Back Button"],
							[UXButton buttonWithStyle:@"toolbarForwardButton:" title:@"Forward Button"],
							
							[UXButton buttonWithStyle:@"blackForwardButton:" title:@"Black Button"],
							[UXButton buttonWithStyle:@"blueToolbarButton:" title:@"Blue Button"],
							[UXButton buttonWithStyle:@"embossedButton:" title:@"Embossed Button"],
							[UXButton buttonWithStyle:@"dropButton:" title:@"Shadow Button"],
							
							[UXButton buttonWithStyle:@"insetBlackActionButton:" title:@"Black Action Title"],
							[UXButton buttonWithStyle:@"insetRedActionButton:"	title:@" Red Action Title "],
							[UXButton buttonWithStyle:@"insetGreenActionButton:" title:@"Green Action Title"],
							[UXButton buttonWithStyle:@"insetDarkBlueActionButton:" title:@"Dark Blue Action Title"],
							[UXButton buttonWithStyle:@"insetBlueActionButton:" title:@"Blue Action Title"],
							[UXButton buttonWithStyle:@"whiteActionButton:" title:@"Gray Action Title"],
							[UXButton buttonWithStyle:@"blueActionButton:" title:@"Blue Action Title"],
							nil];
		
		for (UXButton *button in buttons) {
			button.font = [UIFont boldSystemFontOfSize:_fontSize];
			[button sizeToFit];
			[scrollView addSubview:button];
		}
		[self layout];
	}

@end
