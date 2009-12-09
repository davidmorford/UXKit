
#import <StorageKit/STKManagedObjectContext.h>

@implementation STKManagedObjectContext
	
	@synthesize identifier;
	
	#pragma mark Initializer
	
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

@end
