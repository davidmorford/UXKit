
#import <StorageKit/STKNSSortDescriptor.h>

@implementation NSSortDescriptor (STKNSSortDescriptor)

	+(NSArray *) sortDescriptorsWithString:(NSString *)string {
		NSMutableArray *result = [NSMutableArray array];
		for (NSString *order in [string componentsSeparatedByString:@","]) {
			NSString *key	= nil;
			BOOL ascending	= TRUE;
			for (NSString *element in [order componentsSeparatedByString:@" "]) {
				if ([element length] && key) {
					key = element;
				}
				else {
					if ([element caseInsensitiveCompare:@"asc"] == NSOrderedSame) {
						ascending = TRUE;
					}
					else {
						if ([element caseInsensitiveCompare:@"desc"] == NSOrderedSame) {
							ascending = FALSE;
						}
					}
				}
			}
			if (key) {
				[result addObject:[[[NSSortDescriptor alloc] initWithKey:key ascending:ascending] autorelease]];
			}
		}
		return result;
	}

@end
