
#import <UXKit/UXStoreContext.h>

@interface UXObjectStoreContext ()

@end

#pragma mark -

@implementation UXObjectStoreContext

	@synthesize identifier;
	
	#pragma mark Initializers
	
	-(id) initWithIdentifier:(NSString *)anIdentifer {
		self = [super init];
		if (self) {
			self.identifier = [anIdentifer copy];
		}
		return self;
	}
	
	-(id) initWithIdentifier:(NSString *)anIdentifer persistentStoreCoordinator:(NSPersistentStoreCoordinator *)aCoordinator {
		self = [self initWithIdentifier:anIdentifer];
		if (self) {
			[self setPersistentStoreCoordinator:aCoordinator];
		}
		return self;
	}

	#pragma mark -

	-(void) dealloc {
		[identifier release]; identifier = nil;
		[super dealloc];
	}

@end
