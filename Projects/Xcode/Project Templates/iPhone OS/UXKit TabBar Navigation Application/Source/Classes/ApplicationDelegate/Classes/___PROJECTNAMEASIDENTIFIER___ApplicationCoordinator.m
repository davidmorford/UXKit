
#import "___PROJECTNAMEASIDENTIFIER___ApplicationCoordinator.h"

@interface ___PROJECTNAMEASIDENTIFIER___ApplicationCoordinator ()

@end

#pragma mark -

static ___PROJECTNAMEASIDENTIFIER___ApplicationCoordinator *sharedAppCoordinator = nil;

@implementation ___PROJECTNAMEASIDENTIFIER___ApplicationCoordinator

	#pragma mark Shared Coordinator

	+(___PROJECTNAMEASIDENTIFIER___ApplicationCoordinator *) sharedCoordinator {
		if (sharedAppCoordinator == nil) {
			sharedAppCoordinator = [[super allocWithZone:NULL] init];
		}
		return sharedAppCoordinator;
	}

	+(id) allocWithZone:(NSZone *)zone {
		return [[self sharedCoordinator] retain];
	}

	-(id) copyWithZone:(NSZone *)zone {
		return self;
	}

	-(id) retain {
		return self;
	}

	-(NSUInteger) retainCount {
		return NSUIntegerMax;
	}

	-(void) release {

	}

	-(id) autorelease {
		return self;
	}


	#pragma mark Initializer

	-(id) init {
		self = [super init];
		if (self) {
			[self performSelector:@selector(start) withObject:nil afterDelay:0.5];
		}
		return self;
	}


	#pragma mark NSNotifications

	-(void) didReceiveMemoryWarning:(void *)object {
		UXLOG(@"APPLICATION MEMORY WARNING!");
	}


	#pragma mark KVO

	-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
		UXLOG(@"Coordinator Key Value Observation");
		UXLOG(@"KeyPath = %@", keyPath);
		UXLOG(@"Object  = %@", object);
		UXLOG(@"Changed = %@", change);
		UXLOG(@"================================================================================");
		/*
		if ([keyPath isEqualToString:@""] == TRUE) {
			NSString *previousValue	= [change objectForKey:NSKeyValueChangeOldKey];
			NSString *newValue		= [change objectForKey:NSKeyValueChangeNewKey];
		}
		*/
	}


	#pragma mark Coordinator Main

	-(void) start {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(didReceiveMemoryWarning:)
													 name:UIApplicationDidReceiveMemoryWarningNotification
												   object:nil];
		// KVO
		/*
		[self addObserver:self 
			   forKeyPath:@"" 
				  options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) 
				  context:nil];
		*/
	}


	#pragma mark Memory

	-(void) dealloc {
		[super dealloc];
	}

@end
