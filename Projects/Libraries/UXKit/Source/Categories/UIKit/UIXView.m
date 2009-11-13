
#import <UXKit/UXGlobal.h>

@implementation UIView (UIXView)

	-(CGFloat) left {
		return self.frame.origin.x;
	}

	-(void) setLeft:(CGFloat)x {
		CGRect frame	= self.frame;
		frame.origin.x	= x;
		self.frame		= frame;
	}

	-(CGFloat) top {
		return self.frame.origin.y;
	}

	-(void) setTop:(CGFloat)y {
		CGRect frame	= self.frame;
		frame.origin.y	= y;
		self.frame		= frame;
	}

	-(CGFloat) right {
		return self.frame.origin.x + self.frame.size.width;
	}

	-(void) setRight:(CGFloat)right {
		CGRect frame	= self.frame;
		frame.origin.x	= right - frame.size.width;
		self.frame		= frame;
	}

	-(CGFloat) bottom {
		return self.frame.origin.y + self.frame.size.height;
	}

	-(void) setBottom:(CGFloat)bottom {
		CGRect frame	= self.frame;
		frame.origin.y	= bottom - frame.size.height;
		self.frame		= frame;
	}

	-(CGFloat) centerX {
		return self.center.x;
	}

	-(void) setCenterX:(CGFloat)centerX {
		self.center = CGPointMake(centerX, self.center.y);
	}

	-(CGFloat) centerY {
		return self.center.y;
	}

	-(void) setCenterY:(CGFloat)centerY {
		self.center = CGPointMake(self.center.x, centerY);
	}

	-(CGFloat) width {
		return self.frame.size.width;
	}

	-(void) setWidth:(CGFloat)width {
		CGRect frame		= self.frame;
		frame.size.width	= width;
		self.frame			= frame;
	}

	-(CGFloat) height {
		return self.frame.size.height;
	}

	-(void) setHeight:(CGFloat)height {
		CGRect frame		= self.frame;
		frame.size.height	= height;
		self.frame			= frame;
	}


	#pragma mark -

	-(CGFloat) screenX {
		CGFloat x = 0;
		for (UIView *view = self; view; view = view.superview) {
			x += view.left;
		}
		return x;
	}

	-(CGFloat) screenY {
		CGFloat y = 0;
		for (UIView *view = self; view; view = view.superview) {
			y += view.top;
		}
		return y;
	}

	-(CGFloat) screenViewX {
		CGFloat x = 0;
		for (UIView *view = self; view; view = view.superview) {
			x += view.left;
			
			if ([view isKindOfClass:[UIScrollView class]]) {
				UIScrollView *scrollView = (UIScrollView *)view;
				x -= scrollView.contentOffset.x;
			}
		}
		return x;
	}

	-(CGFloat) screenViewY {
		CGFloat y = 0;
		for (UIView *view = self; view; view = view.superview) {
			y += view.top;
			if ([view isKindOfClass:[UIScrollView class]]) {
				UIScrollView *scrollView = (UIScrollView *)view;
				y -= scrollView.contentOffset.y;
			}
		}
		return y;
	}

	-(CGRect) screenFrame {
		return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
	}


	#pragma mark -

	-(CGPoint) origin {
		return self.frame.origin;
	}

	-(void) setOrigin:(CGPoint)origin {
		CGRect frame	= self.frame;
		frame.origin	= origin;
		self.frame		= frame;
	}

	-(CGSize) size {
		return self.frame.size;
	}

	-(void) setSize:(CGSize)size {
		CGRect frame	= self.frame;
		frame.size		= size;
		self.frame		= frame;
	}


	#pragma mark -

	-(CGPoint) offsetFromView:(UIView *)otherView {
		CGFloat x = 0; 
		CGFloat y = 0;
		for (UIView *view = self; view && view != otherView; view = view.superview) {
			x += view.left;
			y += view.top;
		}
		return CGPointMake(x, y);
	}

	-(CGFloat) orientationWidth {
		return UIInterfaceOrientationIsLandscape(UXInterfaceOrientation()) ? self.height : self.width;
	}

	-(CGFloat) orientationHeight {
		return UIInterfaceOrientationIsLandscape(UXInterfaceOrientation()) ? self.width : self.height;
	}

	-(UIView *) descendantOrSelfWithClass:(Class)cls {
		if ([self isKindOfClass:cls]) {
			return self;
		}
		
		for (UIView *child in self.subviews) {
			UIView *it = [child descendantOrSelfWithClass:cls];
			if (it) {
				return it;
			}
		}
		return nil;
	}

	-(UIView *) ancestorOrSelfWithClass:(Class)cls {
		if ([self isKindOfClass:cls]) {
			return self;
		}
		else if (self.superview) {
			return [self.superview ancestorOrSelfWithClass:cls];
		}
		else {
			return nil;
		}
	}

	-(void) removeAllSubviews {
		while (self.subviews.count) {
			UIView *child = self.subviews.lastObject;
			[child removeFromSuperview];
		}
	}


	#pragma mark -

	-(CGRect) frameWithKeyboardSubtracted:(CGFloat)plusHeight {
		CGRect frame = self.frame;
		if (UXIsKeyboardVisible()) {
			CGRect screenFrame		= UXScreenBounds();
			CGFloat keyboardTop		= (screenFrame.size.height - (UXKeyboardHeight() + plusHeight));
			CGFloat screenBottom	= self.screenY + frame.size.height;
			CGFloat diff			= screenBottom - keyboardTop;
			if (diff > 0) {
				frame.size.height -= diff;
			}
		}
		return frame;
	}

	-(void) presentAsKeyboardAnimationDidStop {
		CGRect screenFrame	= UXScreenBounds();
		CGRect bounds		= CGRectMake(0, 0, screenFrame.size.width, self.height);
		CGPoint centerBegin = CGPointMake(floor(screenFrame.size.width / 2 - self.width / 2), screenFrame.size.height + floor(self.height / 2));
		CGPoint centerEnd	= CGPointMake(floor(screenFrame.size.width / 2 - self.width / 2), screenFrame.size.height - floor(self.height / 2));
		
		NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
								  [NSValue valueWithCGRect:bounds],			UIKeyboardBoundsUserInfoKey,
								  [NSValue valueWithCGPoint:centerBegin],	UIKeyboardCenterBeginUserInfoKey,
								  [NSValue valueWithCGPoint:centerEnd],		UIKeyboardCenterEndUserInfoKey,
								  nil];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"UIKeyboardWillShowNotification" object:self userInfo:userInfo];
	}

	-(void) dismissAsKeyboardAnimationDidStop {
		[self removeFromSuperview];
	}

	-(void) presentAsKeyboardInView:(UIView *)containingView {
		self.top = containingView.height;
		[containingView addSubview:self];
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:UX_TRANSITION_DURATION];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(presentAsKeyboardAnimationDidStop)];
		self.top -= self.height;
		[UIView commitAnimations];
	}

	-(void) dismissAsKeyboard:(BOOL)animated {
		CGRect screenFrame	= UXScreenBounds();
		CGRect bounds		= CGRectMake(0, 0, screenFrame.size.width, self.height);
		CGPoint centerBegin = CGPointMake(floor(screenFrame.size.width / 2 - self.width / 2), screenFrame.size.height - floor(self.height / 2));
		CGPoint centerEnd	= CGPointMake(floor(screenFrame.size.width / 2 - self.width / 2), screenFrame.size.height + floor(self.height / 2));
		
		NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
								  [NSValue valueWithCGRect:bounds],			UIKeyboardBoundsUserInfoKey,
								  [NSValue valueWithCGPoint:centerBegin],	UIKeyboardCenterBeginUserInfoKey,
								  [NSValue valueWithCGPoint:centerEnd],		UIKeyboardCenterEndUserInfoKey, nil];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"UIKeyboardWillHideNotification"
															object:self 
														  userInfo:userInfo];
		
		if (animated) {
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:UX_TRANSITION_DURATION];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(dismissAsKeyboardAnimationDidStop)];
		}
		
		self.top += self.height;
		
		if (animated) {
			[UIView commitAnimations];
		}
		else {
			[self dismissAsKeyboardAnimationDidStop];
		}
	}


	#pragma mark -

	-(UIViewController *) viewController {
		for (UIView *next = [self superview]; next; next = next.superview) {
			UIResponder *nextResponder = [next nextResponder];
			if ([nextResponder isKindOfClass:[UIViewController class]]) {
				return (UIViewController *)nextResponder;
			}
		}
		return nil;
	}

@end

#pragma mark -

@implementation UIView (UIXViewDrawing)

	+(void) drawLinearGradientInRect:(CGRect)rect colors:(CGFloat[])colours {
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextSaveGState(context);
		{
			CGColorSpaceRef rgb		= CGColorSpaceCreateDeviceRGB();
			CGGradientRef gradient	= CGGradientCreateWithColorComponents(rgb, colours, NULL, 2);
			CGColorSpaceRelease(rgb);
			
			CGPoint start;
			start = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height * 0.25);
			
			CGPoint end;
			end = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height * 0.75);
			
			CGContextClipToRect(context, rect);
			CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
			CGGradientRelease(gradient);
		}
		CGContextRestoreGState(context);
	}

	+(void) drawLineInRect:(CGRect)rect colors:(CGFloat[])colors {
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextSaveGState(context);
		{
			CGContextSetRGBStrokeColor(context, colors[0], colors[1], colors[2], colors[3]);
			CGContextSetLineWidth(context, 1);
			CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
			CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
			CGContextStrokePath(context);
		}
		CGContextRestoreGState(context);
	}

@end
