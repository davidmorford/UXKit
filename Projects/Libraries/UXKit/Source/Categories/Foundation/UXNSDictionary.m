
#import <UXKit/UXNSDictionary.h>
#import <UXKit/UXGlobal.h>

@implementation NSMutableDictionary (UXNSMutableDictionary)

	-(void) setNonEmptyString:(NSString *)string forKey:(id)key {
		if ((string != nil) && !UXIsEmptyString(string)) {
			[self setObject:string forKey:key];
		}
	}

@end
