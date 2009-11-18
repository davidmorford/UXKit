
#import <UXKit/UIXBarButtonItem.h>

@implementation UIBarButtonItem (UIXBarButtonItem)

	+(UIBarButtonItem *) plainBarButtonItemWithImage:(UIImage *)anImage target:(id)aTarget action:(SEL)anAction  {
		return [[[UIBarButtonItem alloc] initWithImage:anImage style:UIBarButtonItemStylePlain target:aTarget action:anAction] autorelease];
	}

	+(UIBarButtonItem *) plainBarButtonItemWithTitle:(NSString *)aTitle target:(id)aTarget action:(SEL)anAction  {
		return [[[UIBarButtonItem alloc] initWithTitle:aTitle style:UIBarButtonItemStylePlain target:aTarget action:anAction] autorelease];
	}

	+(UIBarButtonItem *) borderedBarButtonItemWithImage:(UIImage *)anImage target:(id)aTarget action:(SEL)anAction  {
		return [[[UIBarButtonItem alloc] initWithImage:anImage style:UIBarButtonItemStyleBordered target:aTarget action:anAction] autorelease];
	}

	+(UIBarButtonItem *) borderedBarButtonItemWithTitle:(NSString *)aTitle target:(id)aTarget action:(SEL)anAction  {
		return [[[UIBarButtonItem alloc] initWithTitle:aTitle style:UIBarButtonItemStyleBordered target:aTarget action:anAction] autorelease];
	}

	+(UIBarButtonItem *) doneBarButtonItemWithTitle:(NSString *)aTitle target:(id)aTarget action:(SEL)anAction  {
		return [[[UIBarButtonItem alloc] initWithTitle:aTitle style:UIBarButtonItemStyleDone target:aTarget action:anAction] autorelease];
	}

	+(UIBarButtonItem *) systemBarButtonItemWithType:(UIBarButtonSystemItem)systemItem target:(id)aTarget action:(SEL)anAction  {
		return [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:aTarget action:anAction] autorelease];
	}

	+(UIBarButtonItem *) customBarButtonItemWithView:(UIView *)aView target:(id)aTarget action:(SEL)anAction {
		UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:aView];
		item.target = aTarget;
		item.action = anAction;
		return [item autorelease];
	}

	#pragma mark -

	+(UIBarButtonItem *) flexibleSpaceBarItem {
		return [self systemBarButtonItemWithType:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	}

	+(UIBarButtonItem *) fixedSpaceBarItemWithWidth:(CGFloat)spaceWidth {
		UIBarButtonItem *fixedSpace = [self systemBarButtonItemWithType:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		fixedSpace.width = spaceWidth;
		return fixedSpace;
	}

@end
