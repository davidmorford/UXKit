
#import "UXModelObject.h"

@implementation UXModelObject

	#pragma mark <NSCoding>

	-(id) initWithCoder:(NSCoder *)decoder {
		if (self = [super init]) {
		}
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
	}

	#pragma mark <NSCopying>

	-(id) copyWithZone:(NSZone *)zone {
		return [[NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]] retain];
	}

@end
