
#import "StyleTestController.h"

@implementation StyleTestController

	-(void) layout {
		UXFlowLayout *flowLayout	= [[[UXFlowLayout alloc] init] autorelease];
		flowLayout.padding			= 20;
		flowLayout.spacing			= 20;
		CGSize size					= [flowLayout layoutSubviews:self.view.subviews forView:self.view];
		UIScrollView *scrollView	= (UIScrollView *)self.view;
		scrollView.contentSize		= CGSizeMake(scrollView.width, size.height);
	}

	#pragma mark UIViewController

	-(void) loadView {
		UIScrollView *scrollView		= [[[UIScrollView alloc] initWithFrame:UXNavigationFrame()] autorelease];
		scrollView.autoresizesSubviews	= YES;
		scrollView.autoresizingMask		= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		scrollView.backgroundColor		= RGBCOLOR(216, 221, 231);
		//scrollView.backgroundColor	= [UIColor colorWithHue:(0.0/360.0) saturation:(0.0/100.0) brightness:(90.0/100.0) alpha:(100.0/100.0)];
		self.view						= scrollView;
		
		UIColor *black		= RGBCOLOR(158, 163, 172);
		UIColor *blue		= RGBCOLOR(191, 197, 208);
		UIColor *darkBlue	= RGBCOLOR(109, 132, 162);
		
		NSArray *styles = [NSArray arrayWithObjects:
						   // Rectangle
						   [UXSolidFillStyle styleWithColor:[UIColor whiteColor] 
													   next:[UXSolidBorderStyle styleWithColor:black width:1 
													   next:nil]],
						   
						   // Rounded rectangle
						   [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:10] 
												   next:[UXSolidFillStyle styleWithColor:[UIColor whiteColor] 
												   next:[UXSolidBorderStyle styleWithColor:black width:1 next:nil]]],
						   
						   // Gradient border
						   [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:10] 
												   next:[UXSolidFillStyle styleWithColor:[UIColor whiteColor] 
												   next:[UXLinearGradientBorderStyle styleWithColor1:RGBCOLOR(0, 0, 0) color2:RGBCOLOR(216, 221, 231) width:2 
												   next:nil]]],

						   // Rounded left arrow
						   [UXShapeStyle styleWithShape:[UXRoundedLeftArrowShape shapeWithRadius:5] 
												   next:[UXSolidFillStyle styleWithColor:[UIColor whiteColor] 
												   next:[UXSolidBorderStyle styleWithColor:black width:1 
												   next:nil]]],
						   
						   // Partially rounded rectangle
						   [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithTopLeft:0 topRight:0 bottomRight:10 bottomLeft:10] 
												   next:[UXSolidFillStyle styleWithColor:[UIColor whiteColor] 
												   next:[UXSolidBorderStyle styleWithColor:black width:1 
												   next:nil]]],
						   
						   // SpeechBubble
						   [UXShapeStyle styleWithShape:[UXSpeechBubbleShape shapeWithRadius:5 pointLocation:60 pointAngle:90 pointSize:CGSizeMake(20, 10)] 
												   next:[UXSolidFillStyle styleWithColor:[UIColor whiteColor] 
												   next:[UXSolidBorderStyle styleWithColor:black width:1 
												   next:nil]]],
						   
						   // SpeechBubble
						   [UXShapeStyle styleWithShape:[UXSpeechBubbleShape shapeWithRadius:5 pointLocation:290 pointAngle:270 pointSize:CGSizeMake(20, 10)] 
												   next:[UXSolidFillStyle styleWithColor:[UIColor whiteColor] 
												   next:[UXSolidBorderStyle styleWithColor:black width:1 
												   next:nil]]],
						   
						   // Drop shadow
						   [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:10] 
												   next:[UXShadowStyle styleWithColor:RGBACOLOR(0, 0, 0, 0.5) blur:5 offset:CGSizeMake(2, 2) 
												   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(0.25, 0.25, 0.25, 0.25) 
												   next:[UXSolidFillStyle styleWithColor:[UIColor whiteColor] 
												   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(-0.25, -0.25, -0.25, -0.25) 
												   next:[UXSolidBorderStyle styleWithColor:black width:1 
												   next:nil]]]]]],
						   
						   // Inner shadow
						   [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:10] 
												   next:[UXSolidFillStyle styleWithColor:[UIColor whiteColor] 
												   next:[UXInnerShadowStyle styleWithColor:RGBACOLOR(0, 0, 0, 0.5) blur:6 offset:CGSizeMake(1, 1) 
												   next:[UXSolidBorderStyle styleWithColor:black width:1 
												   next:nil]]]],
						   
						   // Chiseled button
						   [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:10] 
												   next:[UXShadowStyle styleWithColor:RGBACOLOR(255, 255, 255, 0.9) blur:1 offset:CGSizeMake(0, 1) 
												   next:[UXLinearGradientFillStyle styleWithColor1:RGBCOLOR(255, 255, 255) color2:RGBCOLOR(216, 221, 231) 
												   next:[UXSolidBorderStyle styleWithColor:blue width:1 
												   next:nil]]]],
						   
						   // Embossed button
						   [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:10] 
												   next:[UXLinearGradientFillStyle styleWithColor1:RGBCOLOR(255, 255, 255) color2:RGBCOLOR(216, 221, 231) 
												   next:[UXFourBorderStyle styleWithTop:blue right:black bottom:black left:blue width:1 
												   next:nil]]],
						   
						   // Toolbar button
						   [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:4.5] 
												   next:[UXShadowStyle styleWithColor:RGBCOLOR(255, 255, 255) blur:1 offset:CGSizeMake(0, 1) 
												   next:[UXReflectiveFillStyle styleWithColor:darkBlue 
												   next:[UXBevelBorderStyle styleWithHighlight:[darkBlue shadow] shadow:[darkBlue multiplyHue:1 saturation:0.5 value:0.5] width:1 lightSource:270 
												   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(0, -1, 0, -1) 
												   next:[UXBevelBorderStyle styleWithHighlight:nil shadow:RGBACOLOR(0, 0, 0, 0.15) width:1 lightSource:270 
												   next:nil]]]]]],
						   
						   // Back button
						   [UXShapeStyle styleWithShape:[UXRoundedLeftArrowShape shapeWithRadius:4.5] 
												   next:[UXShadowStyle styleWithColor:RGBCOLOR(255, 255, 255) blur:1 offset:CGSizeMake(0, 1) 
												   next:[UXReflectiveFillStyle styleWithColor:darkBlue 
												   next:[UXBevelBorderStyle styleWithHighlight:[darkBlue shadow] shadow:[darkBlue multiplyHue:1 saturation:0.5 value:0.5] width:1 lightSource:270 
												   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(0, -1, 0, -1) 
												   next:[UXBevelBorderStyle styleWithHighlight:nil shadow:RGBACOLOR(0, 0, 0, 0.15) width:1 lightSource:270 
												   next:nil]]]]]],
						   
						   // Badge
						   [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:UX_ROUNDED] 
												   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(1.5, 1.5, 1.5, 1.5) 
												   next:[UXShadowStyle styleWithColor:RGBACOLOR(0, 0, 0, 0.8) blur:3 offset:CGSizeMake(0, 5) 
												   next:[UXReflectiveFillStyle styleWithColor:[UIColor redColor] 
												   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(-1.5, -1.5, -1.5, -1.5) 
												   next:[UXSolidBorderStyle styleWithColor:[UIColor whiteColor] width:3 
												   next:nil]]]]]],
						   
						   // Mask
						   [UXMaskStyle styleWithMask:UXIMAGE(@"bundle://mask.png") 
												 next:[UXLinearGradientFillStyle styleWithColor1:RGBCOLOR(0, 180, 231) color2:RGBCOLOR(0, 0, 255) 
												 next:nil]],
						   nil];
		
		CGFloat padding		= 10;
		CGFloat viewWidth	= scrollView.width / 2 - padding * 2;
		CGFloat viewHeight	= UX_ROW_HEIGHT;
		CGFloat x			= padding;
		CGFloat y			= padding;
		
		for (UXStyle *style in styles) {
			if (x + viewWidth >= scrollView.width) {
				x = padding;
				y += viewHeight + padding;
			}
			
			CGRect frame			= CGRectMake(x, y, viewWidth, viewHeight);
			UXView *view			= [[[UXView alloc] initWithFrame:frame] autorelease];
			view.backgroundColor	= scrollView.backgroundColor;
			view.style				= style;
			[scrollView addSubview:view];
			
			x += frame.size.width + padding;
		}
		scrollView.contentSize = CGSizeMake(scrollView.width, y);
		[self layout];
	}

@end
