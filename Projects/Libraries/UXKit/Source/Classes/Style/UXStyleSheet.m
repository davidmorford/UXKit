
#import <UXKit/UXStyleSheet.h>
#import <UXKit/UXDefaultStyleSheet.h>

static UXStyleSheet *gStyleSheet = nil;

@implementation UXStyleSheet

	#pragma mark Shared Constructor

	+(UXStyleSheet *) globalStyleSheet {
		if (!gStyleSheet) {
			gStyleSheet = [[UXDefaultStyleSheet alloc] init];
		}
		return gStyleSheet;
	}

	+(void) setGlobalStyleSheet:(UXStyleSheet *)styleSheet {
		[gStyleSheet release];
		gStyleSheet = [styleSheet retain];
	}


	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			_styles = nil;
			[[NSNotificationCenter defaultCenter] addObserver:self
													 selector:@selector(didReceiveMemoryWarning:)
														 name:UIApplicationDidReceiveMemoryWarningNotification
													   object:nil];
		}
		return self;
	}

	-(void) dealloc {
		[[NSNotificationCenter defaultCenter] removeObserver:self
														name:UIApplicationDidReceiveMemoryWarningNotification
													  object:nil];
		UX_SAFE_RELEASE(_styles);
		[super dealloc];
	}


	#pragma mark NSNotifications

	-(void) didReceiveMemoryWarning:(void *)object {
		[self freeMemory];
	}


	#pragma mark API

//	-(UXStyle *) styleFromResourceBundleForSelector:(NSString *)selector {
//		// First, try to find it in the root of the app bundle
//		NSString *filename	= [NSString stringWithFormat:@"%@.uxstyle", selector];
//		UXStyle *style		= [NSKeyedUnarchiver unarchiveObjectWithFile:UXPathForBundleResource(filename)];
//		if (!style) {
//			// Fallback by looking for it in the UXKit.bundle resource directory
//			filename	= [@"UXKit.bundle/Styles/" stringByAppendingString:filename];
//			style		= [NSKeyedUnarchiver unarchiveObjectWithFile:UXPathForBundleResource(filename)];
//		}
//		return style;
//	}

	-(UXStyle *) styleFromAppBundleForSelector:(NSString *)selector {
		// First, try to find it in the root of the app bundle
		NSString *filename	= [NSString stringWithFormat:@"%@.ttstyle", selector];
		UXStyle *style		= [NSKeyedUnarchiver unarchiveObjectWithFile:UXPathForBundleResource(filename)];
		if (!style) {
			// Fallback by looking for it in the Three20.bundle resource directory
			filename = [@"UXKit.bundle/Styles/" stringByAppendingString:filename];
			style = [NSKeyedUnarchiver unarchiveObjectWithFile:UXPathForBundleResource(filename)];
		}
		
		return style;
	}


	-(UXStyle *) styleWithSelector:(NSString *)selector {
		return [self styleWithSelector:selector forState:UIControlStateNormal];
	}

	-(UXStyle *) styleWithSelector:(NSString *)selector forState:(UIControlState)state {
		NSString *key	= state == UIControlStateNormal ? selector : [NSString stringWithFormat:@"%@%d", selector, state];
		//UXLOG(@"%@", key);
		UXStyle *style	= [_styles objectForKey:key];
		if (!style) {
			SEL sel = NSSelectorFromString(selector);
			style	= [self respondsToSelector:sel] ? [self performSelector:sel withObject:(id)state] : [self styleFromAppBundleForSelector:selector];
			if (style) {
				if (!_styles) {
					_styles = [[NSMutableDictionary alloc] init];
				}
				[_styles setObject:style forKey:key];
			}
		}
		return style;
	}


//	-(UXStyle *) styleWithSelector:(NSString *)selector forState:(UIControlState)state {
//		
//		NSString *key	= state == UIControlStateNormal ? selector : [NSString stringWithFormat:@"%@%d", selector, state];
//		UXStyle *style	= [_styles objectForKey:key];
//		
//		if (!style) {
//			SEL sel = NSSelectorFromString(selector);
//			style	= [self respondsToSelector:sel] ? [self performSelector:sel withObject:(id)state] : [self styleFromResourceBundleForSelector:selector];
//			
//			if (style) {
//				if (!_styles) {
//					_styles = [[NSMutableDictionary alloc] init];
//				}
//				[_styles setObject:style forKey:key];
//			}
//		}
//		return style;
//	}

	/*
	-(UXStyle *) styleWithSelector:(NSString *)selector forState:(UIControlState)state {
		NSString *key	= state == UIControlStateNormal ? selector : [NSString stringWithFormat:@"%@%d", selector, state];
		UXStyle *style	= [_styles objectForKey:key];
		
		if (!style) {
			SEL sel = NSSelectorFromString(selector);
			if ([self respondsToSelector:sel]) {
				style = [self performSelector:sel withObject:(id)state];
				if (style) {
					if (!_styles) {
						_styles = [[NSMutableDictionary alloc] init];
					}
					[_styles setObject:style forKey:key];
				}
			}
		}
		return style;
	}
	*/
	
	-(void) freeMemory {
		UX_SAFE_RELEASE(_styles);
	}

@end
