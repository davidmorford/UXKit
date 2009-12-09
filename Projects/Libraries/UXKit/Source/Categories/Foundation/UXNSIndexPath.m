
#import <UXKit/UXNSIndexPath.h>

@implementation NSIndexPath (UXNSIndexPath)

	+(id) indexPathWithString:(NSString *)aString {
		NSIndexPath *indexPath = [[[NSIndexPath alloc] init] autorelease];
		NSArray *components = [aString componentsSeparatedByString:@","];
		for (NSString *component in components) {
			indexPath = [indexPath indexPathByAddingIndex:[component integerValue]];
		}
		return (indexPath);
	}

	-(NSString *) stringValue {
		NSMutableArray *components = [NSMutableArray arrayWithCapacity:[self length]];
		for (NSUInteger currentIndex = 0; currentIndex != [self length]; ++currentIndex) {
			[components addObject:[NSString stringWithFormat:@"%d", [self indexAtPosition:currentIndex]]];
		}
		return ([components componentsJoinedByString:@","]);
	}

	-(NSUInteger) firstIndex {
		return [self indexAtPosition:0];
	}

	-(NSUInteger) lastIndex {
		return [self indexAtPosition:([self length] - 1)];
	}

	-(NSString *) keyPath {
		return [[self stringByJoiningIndexPathWithSeparator:@"."] substringFromIndex:1];
	}

	-(NSIndexPath *) indexPathByRemovingFirstIndex {
		NSUInteger *indexes = NSZoneCalloc(NSDefaultMallocZone(), [self length], sizeof(NSUInteger));
		NSUInteger *buffer  = NSZoneCalloc(NSDefaultMallocZone(), ([self length] - 1), sizeof(NSUInteger));
		
		[self getIndexes:indexes];
		NSCopyMemoryPages(buffer, &indexes[1], sizeof(NSUInteger) * ([self length] - 1));
		NSZoneFree(NSDefaultMallocZone(), indexes);
		
		return [NSIndexPath indexPathWithIndexes:buffer length:([self length] - 1)];
	}

	-(NSString *) stringByJoiningIndexPathWithSeparator:(NSString *)aSeparator {
		NSString *path          = @"/";
		NSUInteger indexCount   = [self length];
		
		for (NSUInteger currentIndex = 0; currentIndex < indexCount; currentIndex++) {
			path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", [self indexAtPosition:currentIndex]]];
		}
		
		if (aSeparator) {
			path = [path stringByReplacingOccurrencesOfString:@"/" withString:aSeparator];
		}
		
		return path;
	}

@end
