
#import <UXKit/UIXApplication.h>

@implementation UIApplication (UIXApplication)

	+(id) sharedApplicationDelegate {
		return [[UIApplication sharedApplication] delegate];
	}

	+(NSString *) applicationVersion {
		return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
	}

	+(NSString *) documentsDirectory {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		if ([paths count] > 0) {
			return [paths objectAtIndex:0];
		}
		return nil;
	}

	+(NSString *) cachesDirectory {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
		if ([paths count] > 0) {
			return [paths objectAtIndex:0];
		}
		return nil;
	}

@end
