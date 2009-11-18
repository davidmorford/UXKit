
#import <UXKit/UXDefaultStyleSheet.h>
#import <UXKit/UXStyle.h>
#import <UXKit/UXShape.h>
#import <UXKit/UXURLCache.h>
#import <UXKit/UXCalendarTileView.h>

@implementation UXDefaultStyleSheet

	#pragma mark Styles

	-(UXStyle *) linkText:(UIControlState)state {
		if (state == UIControlStateHighlighted) {
			return [UXInsetStyle styleWithInset:UIEdgeInsetsMake(-3, -4, -3, -4) 
										   next:[UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:4.5] 
										   next:[UXSolidFillStyle styleWithColor:[UIColor colorWithWhite:0.75 alpha:1] 
										   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(3, 4, 3, 4) 
										   next:[UXTextStyle styleWithColor:self.linkTextColor 
										   next:nil]]]]];
		}
		else {
			return [UXTextStyle styleWithColor:self.linkTextColor next:nil];
		}
	}

	-(UXStyle *) linkHighlighted {
		return [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:4.5] 
									   next:[UXSolidFillStyle styleWithColor:[UIColor colorWithWhite:0 alpha:0.25] 
									   next:nil]];
	}

	-(UXStyle *) thumbView:(UIControlState)state {
		if (state & UIControlStateHighlighted) {
			return [UXImageStyle styleWithImageURL:nil defaultImage:nil contentMode:UIViewContentModeScaleAspectFill size:CGSizeZero 
											  next:[UXSolidBorderStyle styleWithColor:RGBACOLOR(0, 0, 0, 0.2) width:1 
											  next:[UXSolidFillStyle styleWithColor:RGBACOLOR(0, 0, 0, 0.5) 
											  next:nil]]];
		}
		else {
			return [UXImageStyle styleWithImageURL:nil defaultImage:nil contentMode:UIViewContentModeScaleAspectFill size:CGSizeZero 
												next:[UXSolidBorderStyle styleWithColor:RGBACOLOR(0, 0, 0, 0.2) width:1 
												next:nil]];
		}
	}


	#pragma mark Toolbar

	-(UXStyle *) toolbarButton:(UIControlState)state {
		return [self toolbarButtonForState:state
									 shape:[UXRoundedRectangleShape shapeWithRadius:4.5]
								 tintColor:UXSTYLEVAR(navigationBarTintColor)
									  font:nil];
	}

	-(UXStyle *) toolbarBackButton:(UIControlState)state {
		return [self toolbarButtonForState:state
									 shape:[UXRoundedLeftArrowShape shapeWithRadius:4.5]
								 tintColor:UXSTYLEVAR(navigationBarTintColor)
									  font:nil];
	}

	-(UXStyle *) toolbarForwardButton:(UIControlState)state {
		return [self toolbarButtonForState:state
									 shape:[UXRoundedRightArrowShape shapeWithRadius:4.5]
								 tintColor:UXSTYLEVAR(navigationBarTintColor)
									  font:nil];
	}

	-(UXStyle *) toolbarRoundButton:(UIControlState)state {
		return [self toolbarButtonForState:state
									 shape:[UXRoundedRectangleShape shapeWithRadius:UX_ROUNDED]
								 tintColor:UXSTYLEVAR(navigationBarTintColor)
									  font:nil];
	}

	-(UXStyle *) blackToolbarButton:(UIControlState)state {
		return [self toolbarButtonForState:state
									 shape:[UXRoundedRectangleShape shapeWithRadius:4.5]
								 tintColor:RGBCOLOR(10, 10, 10)
									  font:nil];
	}

	-(UXStyle *) grayToolbarButton:(UIControlState)state {
		return [self toolbarButtonForState:state
									 shape:[UXRoundedRectangleShape shapeWithRadius:4.5]
								 tintColor:RGBCOLOR(40, 40, 40)
									  font:nil];
	}

	-(UXStyle *) blackToolbarForwardButton:(UIControlState)state {
		return [self toolbarButtonForState:state
									 shape:[UXRoundedRightArrowShape shapeWithRadius:4.5]
								 tintColor:RGBCOLOR(10, 10, 10)
									  font:nil];
	}

	-(UXStyle *) blackToolbarRoundButton:(UIControlState)state {
		return [self toolbarButtonForState:state
									 shape:[UXRoundedRectangleShape shapeWithRadius:UX_ROUNDED]
								 tintColor:RGBCOLOR(10, 10, 10)
									  font:nil];
	}


	#pragma mark Search

	-(UXStyle *) searchTextField {
		return [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:UX_ROUNDED] 
									   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(1, 0, 1, 0) 
									   next:[UXShadowStyle styleWithColor:RGBACOLOR(255, 255, 255, 0.4) blur:0 offset:CGSizeMake(0, 1) 
									   next:[UXSolidFillStyle styleWithColor:UXSTYLEVAR(backgroundColor) 
									   next:[UXInnerShadowStyle styleWithColor:RGBACOLOR(0, 0, 0, 0.4) blur:3 offset:CGSizeMake(0, 2) 
									   next:[UXBevelBorderStyle styleWithHighlight:RGBACOLOR(0, 0, 0, 0.25) shadow:RGBACOLOR(0, 0, 0, 0.4) width:1 lightSource:270 
									   next:nil]]]]]];
	}

	-(UXStyle *) searchBar {
		UIColor *color	= UXSTYLEVAR(searchBarTintColor);
		UIColor *highlight	= [color multiplyHue:0 saturation:0 value:1.2];
		UIColor *shadow		= [color multiplyHue:0 saturation:0 value:0.82];
		return [UXLinearGradientFillStyle styleWithColor1:highlight color2:color 
													 next:[UXFourBorderStyle styleWithTop:nil right:nil bottom:shadow left:nil width:1 
													 next:nil]];
	}

	-(UXStyle *) searchTableShadow {
		return [UXLinearGradientFillStyle styleWithColor1:RGBACOLOR(0, 0, 0, 0.18) color2:[UIColor clearColor] 
											         next:[UXFourBorderStyle styleWithTop:RGBCOLOR(130, 130, 130) right:nil bottom:nil left:nil width:1 
													 next:nil]];
	}

	-(UXStyle *) blackSearchBar {
		UIColor* highlight	= [UIColor colorWithWhite:1 alpha:0.05];
		UIColor *mid		= [UIColor colorWithWhite:0.4 alpha:0.6];
		UIColor *shadow		= [UIColor colorWithWhite:0 alpha:0.8];
		return [UXLinearGradientFillStyle styleWithColor1:mid color2:shadow 
													 next:[UXFourBorderStyle styleWithTop:nil right:nil bottom:shadow left:nil width:1 
													 next:[UXFourBorderStyle styleWithTop:nil right:nil bottom:highlight left:nil width:1 
													 next:nil]]];
	}
	
	/*
	-(UXStyle *) searchBarbottom {
		UIColor *color		= UXSTYLEVAR(searchBarTintColor);
		UIColor *highlight	= [color multiplyHue:0 saturation:0 value:1.2];
		UIColor *shadow		= [color multiplyHue:0 saturation:0 value:0.82];
		return [UXLinearGradientFillStyle styleWithColor1:highlight color2:color 
													 next:[UXFourBorderStyle styleWithTop:shadow right:nil bottom:nil left:nil width:1 
													 next:nil]];
	}
	*/	

	#pragma mark Tables
	
	-(UXStyle *) tableHeader {
		UIColor *color		= UXSTYLEVAR(tableHeaderTintColor);
		UIColor *highlight	= [color multiplyHue:0 saturation:0 value:1.1];
		return [UXLinearGradientFillStyle styleWithColor1:highlight color2:color 
													 next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(-1, 0, 0, 0) 
													 next:[UXFourBorderStyle styleWithTop:nil right:nil bottom:RGBACOLOR(0, 0, 0, 0.15) left:nil width:1 
													 next:nil]]];
	}

	-(UXStyle *) tableGroupedHeader {
		return nil;
	}

	-(UXStyle *) pickerCell:(UIControlState)state {
		if (state & UIControlStateSelected) {
			return [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:UX_ROUNDED] 
										   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(1, 1, 1, 1) 
										   next:[UXLinearGradientFillStyle styleWithColor1:RGBCOLOR(79, 144, 255) color2:RGBCOLOR(49, 90, 255) 
										   next:[UXLinearGradientBorderStyle styleWithColor1:RGBCOLOR(161, 187, 283) color2:RGBCOLOR(118, 130, 214) width:1 
										   next:nil]]]];
			
		}
		else {
			return [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:UX_ROUNDED] 
										   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(1, 1, 1, 1) 
										   next:[UXLinearGradientFillStyle styleWithColor1:RGBCOLOR(221, 231, 248) color2:RGBACOLOR(188, 206, 241, 1) 
										   next:[UXFourBorderStyle styleWithTop:RGBCOLOR(161, 187, 283) right:RGBCOLOR(118, 130, 214) bottom:RGBCOLOR(118, 130, 214) left:RGBCOLOR(161, 187, 283) width:1 
										   next:nil]]]];
		}
	}


	#pragma mark Bezels

	-(UXStyle *) blackBezel {
		return [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:10] 
									   next:[UXSolidFillStyle styleWithColor:RGBACOLOR(0, 0, 0, 0.7) 
										next:nil]];
	}

	-(UXStyle *) whiteBezel {
		return [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:10] 
									   next:[UXSolidFillStyle styleWithColor:RGBCOLOR(255, 255, 255) 
									   next:[UXSolidBorderStyle styleWithColor:RGBCOLOR(178, 178, 178) width:1 
									   next:nil]]];
	}

	-(UXStyle *) blackBanner {
		return [UXSolidFillStyle styleWithColor:RGBACOLOR(0, 0, 0, 0.5) 
										   next:[UXFourBorderStyle styleWithTop:RGBCOLOR(0, 0, 0) right:nil bottom:nil left:nil width:1 
										   next:[UXFourBorderStyle styleWithTop:[UIColor colorWithWhite:1 alpha:0.2] right:nil bottom:nil left:nil width:1 
										   next:nil]]];
	}


	#pragma mark Badges

	-(UXStyle *) badgeWithFontSize:(CGFloat)fontSize {
		return [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:UX_ROUNDED] 
									   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(1, 1, 1, 1) 
									   next:[UXShadowStyle styleWithColor:RGBACOLOR(0, 0, 0, 0.8) blur:3 offset:CGSizeMake(0, 4) 
									   next:[UXReflectiveFillStyle styleWithColor:RGBCOLOR(221, 17, 27)
									   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(-1, -1, -1, -1) 
									   next:[UXSolidBorderStyle styleWithColor:[UIColor whiteColor] width:2 
									   next:[UXBoxStyle styleWithPadding:UIEdgeInsetsMake(1, 7, 1, 7) 
									   next:[UXTextStyle styleWithFont:[UIFont boldSystemFontOfSize:fontSize] color:[UIColor whiteColor] 
									   next:nil]]]]]]]];
	}

	-(UXStyle *) miniBadge {
		return [self badgeWithFontSize:12];
	}

	-(UXStyle *) badge {
		return [self badgeWithFontSize:15];
	}

	-(UXStyle *) largeBadge {
		return [self badgeWithFontSize:17];
	}


	#pragma mark Tabs

	-(UXStyle *) tabBar {
		UIColor *border = [UXSTYLEVAR(tabBarTintColor) multiplyHue:0 saturation:0 value:0.7];
		return [UXSolidFillStyle styleWithColor:UXSTYLEVAR(tabBarTintColor) 
											 next:[UXFourBorderStyle styleWithTop:nil right:nil bottom:border left:nil width:1 
											 next:nil]];
	}

	-(UXStyle *) tabStrip {
		UIColor *border = [UXSTYLEVAR(tabTintColor) multiplyHue:0 saturation:0 value:0.4];
		return [UXReflectiveFillStyle styleWithColor:UXSTYLEVAR(tabTintColor) 
												  next:[UXFourBorderStyle styleWithTop:nil right:nil bottom:border left:nil width:1 
												  next:nil]];
	}

	-(UXStyle *) tabGrid {
		UIColor *color		= UXSTYLEVAR(tabTintColor);
		UIColor *lighter	= [color multiplyHue:1 saturation:0.9 value:1.1];
		
		UIColor *highlight	= RGBACOLOR(255, 255, 255, 0.7);
		UIColor *shadow		= [color multiplyHue:1 saturation:1.1 value:0.86];
		return [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:8] 
										 next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(0, -1, -1, -2) 
										 next:[UXShadowStyle styleWithColor:highlight blur:1 offset:CGSizeMake(0, 1) 
										 next:[UXLinearGradientFillStyle styleWithColor1:lighter color2:color 
										 next:[UXSolidBorderStyle styleWithColor:shadow width:1 
										 next:nil]]]]];
	}

	-(UXStyle *) tabGridTabImage:(UIControlState)state {
		return [UXImageStyle styleWithImageURL:nil defaultImage:nil contentMode:UIViewContentModeLeft size:CGSizeZero next:nil];
	}

	-(UXStyle *) tabGridTab:(UIControlState)state corner:(short)corner {
		UXShape *shape = nil;
		if (corner == 1) {
			shape = [UXRoundedRectangleShape shapeWithTopLeft:8 topRight:0 bottomRight:0 bottomLeft:0];
		}
		else if (corner == 2) {
			shape = [UXRoundedRectangleShape shapeWithTopLeft:0 topRight:8 bottomRight:0 bottomLeft:0];
		}
		else if (corner == 3) {
			shape = [UXRoundedRectangleShape shapeWithTopLeft:0 topRight:0 bottomRight:8 bottomLeft:0];
		}
		else if (corner == 4) {
			shape = [UXRoundedRectangleShape shapeWithTopLeft:0 topRight:0 bottomRight:0 bottomLeft:8];
		}
		else if (corner == 5) {
			shape = [UXRoundedRectangleShape shapeWithTopLeft:8 topRight:0 bottomRight:0 bottomLeft:8];
		}
		else if (corner == 6) {
			shape = [UXRoundedRectangleShape shapeWithTopLeft:0 topRight:8 bottomRight:8 bottomLeft:0];
		}
		else {
			shape = [UXRectangleShape shape];
		}
		
		UIColor *highlight = RGBACOLOR(255, 255, 255, 0.7);
		UIColor *shadow = [UXSTYLEVAR(tabTintColor) multiplyHue:1 saturation:1.1 value:0.88];
		
		if (state == UIControlStateSelected) {
			return [UXShapeStyle styleWithShape:shape 
											 next:[UXSolidFillStyle styleWithColor:RGBCOLOR(150, 168, 191) 
											 next:[UXInnerShadowStyle styleWithColor:RGBACOLOR(0, 0, 0, 0.6) blur:3 offset:CGSizeMake(0, 0) 
											 next:[UXBoxStyle styleWithPadding:UIEdgeInsetsMake(11, 10, 9, 10) 
											 next:[UXPartStyle styleWithName:@"image" style:[self tabGridTabImage:state] 
											 next:[UXTextStyle styleWithFont:[UIFont boldSystemFontOfSize:11]  color:RGBCOLOR(255, 255, 255) minimumFontSize:8 shadowColor:RGBACOLOR(0, 0, 0, 0.1) shadowOffset:CGSizeMake(-1, -1) 
											 next:nil]]]]]];
		}
		else {
			return [UXShapeStyle styleWithShape:shape 
											 next:[UXBevelBorderStyle styleWithHighlight:highlight shadow:shadow width:1 lightSource:125 
											 next:[UXBoxStyle styleWithPadding:UIEdgeInsetsMake(11, 10, 9, 10) 
											 next:[UXPartStyle styleWithName:@"image" style:[self tabGridTabImage:state] 
											 next:[UXTextStyle styleWithFont:[UIFont boldSystemFontOfSize:11]  color:self.linkTextColor minimumFontSize:8 shadowColor:[UIColor colorWithWhite:255 alpha:0.9] shadowOffset:CGSizeMake(0, -1) 
											 next:nil]]]]];
		}
	}

	-(UXStyle *) tabGridTabTopLeft:(UIControlState)state {
		return [self tabGridTab:state corner:1];
	}

	-(UXStyle *) tabGridTabTopRight:(UIControlState)state {
		return [self tabGridTab:state corner:2];
	}

	-(UXStyle *) tabGridTabbottomRight:(UIControlState)state {
		return [self tabGridTab:state corner:3];
	}

	-(UXStyle *) tabGridTabbottomLeft:(UIControlState)state {
		return [self tabGridTab:state corner:4];
	}

	-(UXStyle *) tabGridTabLeft:(UIControlState)state {
		return [self tabGridTab:state corner:5];
	}

	-(UXStyle *) tabGridTabRight:(UIControlState)state {
		return [self tabGridTab:state corner:6];
	}

	-(UXStyle *) tabGridTabCenter:(UIControlState)state {
		return [self tabGridTab:state corner:0];
	}


	#pragma mark -

	-(UXStyle *) tab:(UIControlState)state {
		if (state == UIControlStateSelected) {
			UIColor *border = [UXSTYLEVAR(tabBarTintColor) multiplyHue:0 saturation:0 value:0.7];
			return [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithTopLeft:4.5 topRight:4.5 bottomRight:0 bottomLeft:0] 
										   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(5, 1, 0, 1) 
										   next:[UXReflectiveFillStyle styleWithColor:UXSTYLEVAR(tabTintColor) 
										   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(-1, -1, 0, -1) 
										   next:[UXFourBorderStyle styleWithTop:border right:border bottom:nil left:border width:1 
										   next:[UXBoxStyle styleWithPadding:UIEdgeInsetsMake(6, 12, 2, 12) 
										   next:[UXTextStyle styleWithFont:[UIFont boldSystemFontOfSize:14]  color:UXSTYLEVAR(textColor) minimumFontSize:8 shadowColor:[UIColor colorWithWhite:1 alpha:0.8] shadowOffset:CGSizeMake(0, -1) 
										   next:nil]]]]]]];
		}
		else {
			return [UXInsetStyle styleWithInset:UIEdgeInsetsMake(5, 1, 1, 1) 
											 next:[UXBoxStyle styleWithPadding:UIEdgeInsetsMake(6, 12, 2, 12) 
											 next:[UXTextStyle styleWithFont:[UIFont boldSystemFontOfSize:14] 
																	   color:[UIColor whiteColor] 
															 minimumFontSize:8 
																 shadowColor:[UIColor colorWithWhite:0 alpha:0.6] 
																shadowOffset:CGSizeMake(0, -1) 
																		next:nil]]];
		}
	}

	-(UXStyle *) tabRound:(UIControlState)state {
		if (state == UIControlStateSelected) {
			return [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:UX_ROUNDED] 
										   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(9, 1, 8, 1) 
										   next:[UXShadowStyle styleWithColor:RGBACOLOR(255, 255, 255, 0.8) blur:0 offset:CGSizeMake(0, 1) 
										   next:[UXReflectiveFillStyle styleWithColor:UXSTYLEVAR(tabBarTintColor) 
										   next:[UXInnerShadowStyle styleWithColor:RGBACOLOR(0, 0, 0, 0.3) blur:1 offset:CGSizeMake(1, 1) 
										   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(-1, -1, -1, -1) 
										   next:[UXBoxStyle styleWithPadding:UIEdgeInsetsMake(0, 10, 0, 10) 
										   next:[UXTextStyle styleWithFont:[UIFont boldSystemFontOfSize:13] color:[UIColor whiteColor] minimumFontSize:8 shadowColor:[UIColor colorWithWhite:0 alpha:0.5] shadowOffset:CGSizeMake(0, -1) 
										   next:nil]]]]]]]];
		}
		else {
			return [UXBoxStyle styleWithPadding:UIEdgeInsetsMake(0, 10, 0, 10) 
											 next:[UXTextStyle styleWithFont:[UIFont boldSystemFontOfSize:13]  color:self.linkTextColor minimumFontSize:8 shadowColor:[UIColor colorWithWhite:1 alpha:0.9] shadowOffset:CGSizeMake(0, -1) 
											 next:nil]];
		}
	}

	-(UXStyle *) tabOverflowLeft {
		UIImage *image = UXIMAGE(@"bundle://UXKit.bundle/Images/Tab/overflowLeft.png");
		UXImageStyle *style = [UXImageStyle styleWithImage:image next:nil];
		style.contentMode = UIViewContentModeCenter;
		return style;
	}

	-(UXStyle *) tabOverflowRight {
		UIImage *image		= UXIMAGE(@"bundle://UXKit.bundle/Images/Tab/overflowRight.png");
		UXImageStyle *style = [UXImageStyle styleWithImage:image next:nil];
		style.contentMode	= UIViewContentModeCenter;
		return style;
	}


	#pragma mark -

	-(UXStyle *) rounded {
		return [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:8] next:[UXContentStyle styleWithNext:nil]];
	}


	#pragma mark Post Editor

	-(UXStyle *) postTextEditor {
		return [UXInsetStyle styleWithInset:UIEdgeInsetsMake(6, 5, 6, 5) 
									   next:[UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:15] 
									   next:[UXSolidFillStyle styleWithColor:[UIColor whiteColor] 
									   next:nil]]];
	}


	#pragma mark Photos

	-(UXStyle *) photoCaption {
		return [UXSolidFillStyle styleWithColor:[UIColor colorWithWhite:0 alpha:0.5] 
											 next:[UXFourBorderStyle styleWithTop:RGBACOLOR(0, 0, 0, 0.5) width:1 
											 next:[UXBoxStyle styleWithPadding:UIEdgeInsetsMake(8, 8, 8, 8)
											 next:[UXTextStyle styleWithFont:UXSTYLEVAR(photoCaptionFont) 
																		 color:UXSTYLEVAR(photoCaptionTextColor) 
															   minimumFontSize:0 
																   shadowColor:[UIColor colorWithWhite:0 alpha:0.9] 
																  shadowOffset:CGSizeMake(0, 1) 
																 textAlignment:UITextAlignmentLeft 
															 verticalAlignment:UIControlContentVerticalAlignmentCenter 
																 lineBreakMode:UILineBreakModeTailTruncation 
																 numberOfLines:12 /*6*/ 
																          next:nil]]]];
	}

	-(UXStyle *) photoStatusLabel {
		return [UXSolidFillStyle styleWithColor:[UIColor colorWithWhite:0 alpha:0.5]
											 next:[UXBoxStyle styleWithPadding:UIEdgeInsetsMake(20, 8, 20, 8) 
											 next:[UXTextStyle styleWithFont:UXSTYLEVAR(tableFont) color:RGBCOLOR(200, 200, 200) minimumFontSize:0 shadowColor:[UIColor colorWithWhite:0 alpha:0.9] shadowOffset:CGSizeMake(0, -1) 
											next:nil]]];
	}

	-(UXStyle *) pageDot:(UIControlState)aState {
		if (aState == UIControlStateSelected) {
			return [self pageDotWithColor:[UIColor whiteColor]];
		}
		else {
			return [self pageDotWithColor:RGBCOLOR(77, 77, 77)];
		}
	}


	#pragma mark Photos

	-(UXStyle *) launcherButton:(UIControlState)state {
		return [UXPartStyle styleWithName:@"image" style:UXSTYLESTATE(launcherButtonImage:, state) 
									 next:[UXTextStyle styleWithFont:[UIFont boldSystemFontOfSize:11] color:RGBCOLOR(180, 180, 180) minimumFontSize:11 shadowColor:nil shadowOffset:CGSizeZero 
									 next:nil]];
	}

	-(UXStyle *) launcherButtonImage:(UIControlState)state {
		UXStyle *style = [UXBoxStyle styleWithMargin:UIEdgeInsetsMake(-7, 0, 11, 0) 
												next:[UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:8] 
												next:[UXImageStyle styleWithImageURL:nil defaultImage:nil contentMode:UIViewContentModeCenter size:CGSizeZero 
												next:nil]]];
		
		if ((state == UIControlStateHighlighted) || (state == UIControlStateSelected) ) {
			[style addStyle:[UXBlendStyle styleWithBlend:kCGBlendModeSourceAtop 
													next:[UXSolidFillStyle styleWithColor:RGBACOLOR(0, 0, 0, 0.5) 
													next:nil]]];
		}
		return style;
	}

	-(UXStyle *) launcherCloseButtonImage:(UIControlState)state {
		return [UXBoxStyle styleWithMargin:UIEdgeInsetsMake(-2, 0, 0, 0) 
									  next:[UXImageStyle styleWithImageURL:nil defaultImage:nil contentMode:UIViewContentModeCenter size:CGSizeMake(10, 10) 
									  next:nil]];
	}

	-(UXStyle *) launcherCloseButton:(UIControlState)state {
		return [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:UX_ROUNDED] 
									   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(1, 1, 1, 1) 
									   next:[UXShadowStyle styleWithColor:RGBACOLOR(0, 0, 0, 0.5) blur:2 offset:CGSizeMake(0, 3) 
									   next:[UXSolidFillStyle styleWithColor:[UIColor blackColor] 
									   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(-1, -1, -1, -1) 
									   next:[UXSolidBorderStyle styleWithColor:[UIColor whiteColor] width:2 
									   next:[UXPartStyle styleWithName:@"image" style:UXSTYLE(launcherCloseButtonImage:) 
									   next:nil]]]]]]];
	}

	-(UXStyle *) launcherPageDot:(UIControlState)state {
		return [self pageDot:state];
	}


	#pragma mark Text Bar

	-(UXStyle *) textBar {
		return [UXLinearGradientFillStyle styleWithColor1:RGBCOLOR(237, 239, 241) color2:RGBCOLOR(206, 208, 212) 
													next:[UXFourBorderStyle styleWithTop:RGBCOLOR(187, 189, 190) right:nil bottom:nil left:nil width:1 
													next:[UXFourBorderStyle styleWithTop:RGBCOLOR(255, 255, 255) right:nil bottom:nil left:nil width:1
													next:nil]]];
	}

	-(UXStyle *) textBarFooter {
		return [UXLinearGradientFillStyle styleWithColor1:RGBCOLOR(206, 208, 212) color2:RGBCOLOR(184, 186, 190) 
													 next:[UXFourBorderStyle styleWithTop:RGBCOLOR(161, 161, 161) right:nil bottom:nil left:nil width:1 
													 next:[UXFourBorderStyle styleWithTop:RGBCOLOR(230, 232, 235) right:nil bottom:nil left:nil width:1 
													 next:nil]]];
	}

	-(UXStyle *) textBarTextField {
		return [UXInsetStyle styleWithInset:UIEdgeInsetsMake(6, 0, 3, 6) next:
				[UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:12.5] next:
				 [UXInsetStyle styleWithInset:UIEdgeInsetsMake(1, 0, 1, 0) next:
				  [UXShadowStyle styleWithColor:RGBACOLOR(255, 255, 255, 0.4) blur:0 offset:CGSizeMake(0, 1) next:
				   [UXSolidFillStyle styleWithColor:UXSTYLEVAR(backgroundColor) next:
					[UXInnerShadowStyle styleWithColor:RGBACOLOR(0, 0, 0, 0.4) blur:3 offset:CGSizeMake(0, 2) next:
					 [UXBevelBorderStyle styleWithHighlight:RGBACOLOR(0, 0, 0, 0.25) shadow:RGBACOLOR(0, 0, 0, 0.4) width:1 lightSource:270 
													   next:nil]]]]]]];
	}

	-(UXStyle *) textBarPostButton:(UIControlState)state {
		UIColor *fillColor = state == UIControlStateHighlighted ? RGBCOLOR(19, 61, 126) : RGBCOLOR(31, 100, 206);
		UIColor *textColor = state == UIControlStateDisabled ? RGBACOLOR(255, 255, 255, 0.5) : RGBCOLOR(255, 255, 255);
		return [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:13] next:
				[UXInsetStyle styleWithInset:UIEdgeInsetsMake(2, 0, 1, 0) next:
				 [UXShadowStyle styleWithColor:RGBACOLOR(255, 255, 255, 0.5) blur:0 offset:CGSizeMake(0, 1) next:
				  [UXReflectiveFillStyle styleWithColor:fillColor next:
				   [UXLinearGradientBorderStyle styleWithColor1:fillColor color2:RGBCOLOR(14, 83, 187) width:1 next:
					[UXInsetStyle styleWithInset:UIEdgeInsetsMake(0, -1, 0, -1) next:
					 [UXBoxStyle styleWithPadding:UIEdgeInsetsMake(8, 9, 8, 9) next:
					  [UXTextStyle styleWithFont:[UIFont boldSystemFontOfSize:15] color:textColor shadowColor:[UIColor colorWithWhite:0 alpha:0.3] shadowOffset:CGSizeMake(0, -1) 
											next:nil]]]]]]]];
	}


	#pragma mark Panel

	-(UXStyle *) panelShine {
		return [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:0] 
									   next:[UXLinearGradientFillStyle styleWithColor1:[UIColor colorWithWhite:0.2 alpha:0.8] color2:[UIColor colorWithWhite:0.1 alpha:0.9]  
									   next:[UXRadialShine radialShineWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] 
									   next:nil]]];
	}


	#pragma mark Colors

	-(UIColor *) textColor {
		return [UIColor blackColor];
	}

	-(UIColor *) highlightedTextColor {
		return [UIColor whiteColor];
	}

	-(UIColor *) placeholderTextColor {
		return RGBCOLOR(180, 180, 180);
	}

	-(UIColor *) timestampTextColor {
		return RGBCOLOR(36, 112, 216);
	}

	-(UIColor *) linkTextColor {
		return RGBCOLOR(87, 107, 149);
	}

	-(UIColor *) moreLinkTextColor {
		return RGBCOLOR(36, 112, 216);
	}

	-(UIColor *) selectedTextColor {
		return [UIColor whiteColor];
	}

	-(UIColor *) photoCaptionTextColor {
		return [UIColor whiteColor];
	}

	-(UIColor *) navigationBarTintColor {
		return RGBCOLOR(119, 140, 168);
	}

	-(UIColor *) toolbarTintColor {
		return RGBCOLOR(109, 132, 162);
	}

	-(UIColor *) segmentedControlTintColor {
		return RGBCOLOR(109, 132, 162);
	}

	-(UIColor *) searchBarTintColor {
		return RGBCOLOR(200, 200, 200);
	}

	-(UIColor *) screenBackgroundColor {
		return [UIColor colorWithWhite:0 alpha:0.8];
	}

	-(UIColor *) backgroundColor {
		return [UIColor whiteColor];
	}

	-(UIColor *) launcherBackgroundColor {
		return [UIColor blackColor];
	}

	-(UIColor *) tableActivityTextColor {
		return RGBCOLOR(99, 109, 125);
	}

	-(UIColor *) tableErrorTextColor {
		return RGBCOLOR(96, 103, 111);
	}

	-(UIColor *) tableSubTextColor {
		return RGBCOLOR(79, 89, 105);
	}

	-(UIColor *) tableTitleTextColor {
		return RGBCOLOR(99, 109, 125);
	}

	-(UIColor *) tableHeaderTextColor {
		return nil;
	}

	-(UIColor *) tableHeaderShadowColor {
		return nil;
	}

	-(UIColor *) tableHeaderTintColor {
		return nil;
	}

	-(UIColor *) tableSeparatorColor {
		return [UIColor colorWithWhite:0.9 alpha:1];
	}

	-(UIColor *) tablePlainBackgroundColor {
		return nil;
	}

	-(UIColor *) tableGroupedBackgroundColor {
		return [UIColor groupTableViewBackgroundColor];
	}

	-(UIColor *) searchTableBackgroundColor {
		return RGBCOLOR(235, 235, 235);
	}

	-(UIColor *) searchTableSeparatorColor {
		return [UIColor colorWithWhite:0.85 alpha:1];
	}

	-(UIColor *) tabBarTintColor {
		return RGBCOLOR(119, 140, 168);
	}

	-(UIColor *) tabTintColor {
		return RGBCOLOR(228, 230, 235);
	}

	-(UIColor *) messageFieldTextColor {
		return [UIColor colorWithWhite:0.5 alpha:1];
	}

	-(UIColor *) messageFieldSeparatorColor {
		return [UIColor colorWithWhite:0.7 alpha:1];
	}

	-(UIColor *) thumbnailBackgroundColor {
		return [UIColor colorWithWhite:0.95 alpha:1];
	}

	-(UIColor *) postButtonColor {
		return RGBCOLOR(117, 144, 181);
	}


	#pragma mark Fonts

	-(UIFont *) font {
		return [UIFont systemFontOfSize:14];
	}

	-(UIFont *) buttonFont {
		return [UIFont boldSystemFontOfSize:12];
	}

	-(UIFont *) tableFont {
		return [UIFont boldSystemFontOfSize:17];
	}

	-(UIFont *) tableSmallFont {
		return [UIFont boldSystemFontOfSize:15];
	}

	-(UIFont *) tableTitleFont {
		return [UIFont boldSystemFontOfSize:13];
	}

	-(UIFont *) tableTimestampFont {
		return [UIFont systemFontOfSize:13];
	}

	-(UIFont *) tableButtonFont {
		return [UIFont boldSystemFontOfSize:13];
	}

	-(UIFont *) tableSummaryFont {
		return [UIFont systemFontOfSize:17];
	}

	-(UIFont *) tableHeaderPlainFont {
		return [UIFont boldSystemFontOfSize:16];
	}

	-(UIFont *) tableHeaderGroupedFont {
		return [UIFont boldSystemFontOfSize:18];
	}

	-(UIFont *) photoCaptionFont {
		return [UIFont systemFontOfSize:13];
		//return [UIFont boldSystemFontOfSize:12];
	}

	-(UIFont *) messageFont {
		return [UIFont systemFontOfSize:15];
	}

	-(UIFont *) errorTitleFont {
		return [UIFont boldSystemFontOfSize:18];
	}

	-(UIFont *) errorSubtitleFont {
		return [UIFont boldSystemFontOfSize:12];
	}

	-(UIFont *) activityLabelFont {
		return [UIFont systemFontOfSize:17];
	}

	-(UIFont *) activityBannerFont {
		return [UIFont boldSystemFontOfSize:11];
	}

	-(UITableViewCellSelectionStyle) tableSelectionStyle {
		return UITableViewCellSelectionStyleBlue;
	}
	

	#pragma mark SPI

	-(UIColor *) toolbarButtonColorWithTintColor:(UIColor *)aColor forState:(UIControlState)aState {
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

	-(UIColor *) toolbarButtonTextColorForState:(UIControlState)aState {
		if (aState & UIControlStateDisabled) {
			return [UIColor colorWithWhite:1 alpha:0.4];
		}
		else {
			return [UIColor whiteColor];
		}
	}


	#pragma mark API

	-(UXStyle *) selectionFillStyle:(UXStyle *)aNextStyle {
		return [UXLinearGradientFillStyle styleWithColor1:RGBCOLOR(5, 140, 245) 
												   color2:RGBCOLOR(1, 93, 230) 
													 next:aNextStyle];
	}

	-(UXStyle *) toolbarButtonForState:(UIControlState)aState shape:(UXShape *)aShape tintColor:(UIColor *)aColor font:(UIFont *)aFont {
		UIColor *stateTintColor = [self toolbarButtonColorWithTintColor:aColor forState:aState];
		UIColor *stateTextColor = [self toolbarButtonTextColorForState:aState];
		return [UXShapeStyle styleWithShape:aShape
									   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(2, 0, 1, 0)
									   next:[UXShadowStyle styleWithColor:RGBACOLOR(255, 255, 255, 0.18) blur:0 offset:CGSizeMake(0, 1)
									   next:[UXReflectiveFillStyle styleWithColor:stateTintColor
									   next:[UXBevelBorderStyle styleWithHighlight:[stateTintColor multiplyHue:1 saturation:0.9 value:0.7] shadow:[stateTintColor multiplyHue:1 saturation:0.5 value:0.6] width:1 lightSource:270
									   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(0, -1, 0, -1)
									   next:[UXBevelBorderStyle styleWithHighlight:nil shadow:RGBACOLOR(0, 0, 0, 0.15) width:1 lightSource:270
									   next:[UXBoxStyle styleWithPadding:UIEdgeInsetsMake(8, 8, 8, 8)
									   next:[UXImageStyle styleWithImageURL:nil defaultImage:nil contentMode:UIViewContentModeScaleToFill size:CGSizeZero
									   next:[UXTextStyle styleWithFont:aFont color:stateTextColor shadowColor:[UIColor colorWithWhite:0 alpha:0.4] shadowOffset:CGSizeMake(0, -1)
									   next:nil]]]]]]]]]];
	}

	-(UXStyle *) pageDotWithColor:(UIColor *)aColor {
		return	[UXBoxStyle styleWithMargin:UIEdgeInsetsMake(0, 0, 0, 10) padding:UIEdgeInsetsMake(6, 6, 0, 0) 
									   next:[UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:2.5] 
									   next:[UXSolidFillStyle styleWithColor:aColor 
									   next:nil]]];
	}


	#pragma mark Calendar Styles

	-(UIColor *)calendarHeaderTopColor {
		return RGBCOLOR(246, 246, 247);
	}

	-(UIColor *)calendarHeaderBottomColor {
		return RGBCOLOR(204, 204, 209);
	}

	-(UIColor *) calendarGridTopColor {
		return RGBCOLOR(226, 226, 229);
	}

	-(UIColor *) calendarGridBottomColor {
		return RGBCOLOR(200, 200, 205);
	}

	-(UIColor *) calendarTextColor {
		return RGBCOLOR(59, 73, 88);
	}

	-(UIColor *) calendarTextLightColor {
		return RGBCOLOR(147, 155, 165);
	}

	-(UIColor *) calendarTileDimmedOutColor {
		return RGBACOLOR(0, 0, 0, 0.25);
	}

	-(UIColor *) calendarGridLineHighlightColor {
		return RGBCOLOR(159, 162, 172);
	}

	-(UIColor *) calendarGridLineShadowColor {
		return RGBCOLOR(237, 237, 239);
	}

	-(UIColor *) calendarContentSeparatorColor {
		return RGBCOLOR(151, 154, 155);
	}


	#pragma mark -

	-(UXStyle *) calendarTileWithColor:(UIColor *)color {
		return [UXFourBorderStyle styleWithTop:UXSTYLEVAR(calendarGridLineHighlightColor) right:UXSTYLEVAR(calendarGridLineHighlightColor) bottom:nil left:nil width:1.f 
										  next:[UXFourBorderStyle styleWithTop:UXSTYLEVAR(calendarGridLineShadowColor) right:UXSTYLEVAR(calendarGridLineShadowColor) bottom:nil left:nil width:1.f 
										  next:[UXTextStyle styleWithFont:[UIFont boldSystemFontOfSize:24.f] color:color shadowColor:[UIColor whiteColor] shadowOffset:CGSizeMake(0.f, 1.f) 
										  next:nil]]];
	}

	-(UXStyle *) calendarTileMarkWithColor:(UIColor *)color {
		return [UXInsetStyle styleWithInset:UIEdgeInsetsMake(35, 20, 6, 20) next:
				[UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:UX_ROUNDED] next:
				 [UXSolidFillStyle styleWithColor:color next:nil]]];
	}

	-(UXStyle *) calendarTileSelected {
		return [UXSolidFillStyle styleWithColor:[UIColor blueColor]  
										   next:[UXSolidBorderStyle styleWithColor:[UIColor colorWithWhite:0 alpha:1.0] width:1 
										   next:[UXReflectiveFillStyle styleWithColor:RGBCOLOR(59, 73, 88) /*RGBCOLOR(0.1, 0.6, 1)*/ 
										   next:[UXTextStyle styleWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:24.0] 
																	   color:[UIColor whiteColor]
																 shadowColor:[UIColor grayColor]
																shadowOffset:CGSizeMake(0, -1)
																next:nil]]]];
	}

	-(UXStyle *) calendarTileForState:(UIControlState)state {
		UXStyle *style = nil;
		UIColor *markColor = nil;
		
		switch (state & UXCalendarTileStateMode) {
				
			case kUXCalendarTileTypeRegular:
				if (state & UIControlStateSelected) {
					//style = UXSTYLE(calendar_tile_selected);
					style = UXSTYLE(calendarTileSelected);
					markColor = [UIColor whiteColor];
				}
				else {
					style = [self calendarTileWithColor:UXSTYLEVAR(calendarTextColor)];
					markColor = UXSTYLEVAR(calendarTextColor);
				}
				break;
				
			case kUXCalendarTileTypeAdjacent:
				style = [self calendarTileWithColor:UXSTYLEVAR(calendarTextLightColor)];
				markColor = UXSTYLEVAR(calendarTextLightColor);
				if (state & UIControlStateSelected) {
					[style addStyle:[UXSolidFillStyle styleWithColor:UXSTYLEVAR(calendarTileDimmedOutColor) next:nil]];
				}
				break;
				
			case kUXCalendarTileTypeToday:
				markColor = [UIColor whiteColor];
				style = state & UIControlStateSelected ? UXSTYLE(calendar_tile_today_selected) : UXSTYLE(calendar_tile_today);
				break;
				
			default:
				[NSException raise:@"Cannot find calendar tile style" format:@"unknown error"];
				break;
		}
		
		if (state & UXCalendarTileStateMarked) {
			style = [[style copy] autorelease];
			[style addStyle:[self calendarTileMarkWithColor:markColor]];
		}
		
		return style;
	}


	#pragma mark Panel

	-(UXStyle *) panelContent {
		return [UXInsetStyle styleWithInset:UIEdgeInsetsMake(0, 0, 0, 0) 
									   next:[UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithTopLeft:2 topRight:2 bottomRight:2 bottomLeft:2]
									   next:[UXSolidFillStyle styleWithColor:[UIColor colorWithWhite:1.0 alpha:0.5] 
									   next:nil]]];
	}

	-(UXStyle *) panel {
		return [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithTopLeft:0 topRight:0 bottomRight:5 bottomLeft:5]
									   next:[UXLinearGradientFillStyle styleWithColor1:RGBCOLOR(237, 239, 241) color2:RGBCOLOR(186, 188, 192) 
									   next:[UXFourBorderStyle styleWithTop:RGBCOLOR(28, 30, 32) right:nil bottom:nil left:nil width:0.5 
									   next:nil]]];
	}

@end
