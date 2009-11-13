
#import <UXKit/UXGlobal.h>
#import <UXKit/UXURLRequestQueue.h>
#import <UXKit/UXNavigator.h>
#import <UXKit/UXURLMap.h>

@implementation UINavigationController (UIXNavigationController)

	#pragma mark SPI

	-(void) pushAnimationDidStop {
		[UXURLRequestQueue mainQueue].suspended = NO;
	}

	-(UIViewAnimationTransition) invertTransition:(UIViewAnimationTransition)transition {
		switch (transition) {
			case UIViewAnimationTransitionCurlUp:
				return UIViewAnimationTransitionCurlDown;
			case UIViewAnimationTransitionCurlDown:
				return UIViewAnimationTransitionCurlUp;
			case UIViewAnimationTransitionFlipFromLeft:
				return UIViewAnimationTransitionFlipFromRight;
			case UIViewAnimationTransitionFlipFromRight:
				return UIViewAnimationTransitionFlipFromLeft;
			default:
				return UIViewAnimationTransitionNone;
		}
	}

	-(UIViewController *) popViewControllerAnimated2:(BOOL)animated {
		if (animated) {
			NSString *URL							= self.topViewController.originalNavigatorURL;
			UIViewAnimationTransition transition	= URL ? [[UXNavigator navigator].URLMap transitionForURL:URL] : UIViewAnimationTransitionNone;
			if (transition) {
				UIViewAnimationTransition inverseTransition = [self invertTransition:transition];
				return [self popViewControllerAnimatedWithTransition:inverseTransition];
			}
		}
		return [self popViewControllerAnimated2:animated];
	}


	#pragma mark (UIXViewController)

	-(UIView *) rotatingHeaderView {
		UIViewController *popup = [self popupViewController];
		if (popup) {
			return [popup rotatingHeaderView];
		}
		else {
			return [super rotatingHeaderView];
		}
	}

	-(BOOL) canContainControllers {
		return YES;
	}

	-(UIViewController *) topSubcontroller {
		return self.topViewController;
	}

	-(void) addSubcontroller:(UIViewController *)controller animated:(BOOL)animated transition:(UIViewAnimationTransition)transition {
		if (animated && transition) {
			[self pushViewController:controller animatedWithTransition:transition];
		}
		else {
			[self pushViewController:controller animated:animated];
		}
	}

	-(void) bringControllerToFront:(UIViewController *)controller animated:(BOOL)animated {
		if (([self.viewControllers indexOfObject:controller] != NSNotFound) && (controller != self.topViewController)) {
			[self popToViewController:controller animated:animated];
		}
	}

	-(NSString *) keyForSubcontroller:(UIViewController *)controller {
		NSInteger index = [self.viewControllers indexOfObject:controller];
		if (index != NSNotFound) {
			return [NSNumber numberWithInt:index].stringValue;
		}
		else {
			return nil;
		}
	}

	-(UIViewController *) subcontrollerForKey:(NSString *)key {
		NSInteger index = key.intValue;
		if (index < self.viewControllers.count) {
			return [self.viewControllers objectAtIndex:index];
		}
		else {
			return nil;
		}
	}

	-(void) persistNavigationPath:(NSMutableArray *)path {
		for (UIViewController *controller in self.viewControllers) {
			[[UXNavigator navigator] persistController:controller path:path];
		}
	}


	#pragma mark API

	-(void) pushViewController:(UIViewController *)controller animatedWithTransition:(UIViewAnimationTransition)transition {
		[UXURLRequestQueue mainQueue].suspended = YES;
		
		[self pushViewController:controller animated:NO];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:UX_FLIP_TRANSITION_DURATION];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(pushAnimationDidStop)];
		[UIView setAnimationTransition:transition forView:self.view cache:YES];
		[UIView commitAnimations];
	}

	-(UIViewController *) popViewControllerAnimatedWithTransition:(UIViewAnimationTransition)transition {
		[UXURLRequestQueue mainQueue].suspended	= YES;
		UIViewController *poppedController			= [self popViewControllerAnimated:NO];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:UX_FLIP_TRANSITION_DURATION];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(pushAnimationDidStop)];
		[UIView setAnimationTransition:transition forView:self.view cache:NO];
		[UIView commitAnimations];
		
		return poppedController;
	}

@end
