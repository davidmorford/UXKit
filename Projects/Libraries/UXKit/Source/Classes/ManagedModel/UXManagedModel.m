
#import <UXKit/UXManagedModel.h>

@interface UXManagedModel ()

@end

#pragma mark -

@implementation UXManagedModel

	@synthesize name;
	@synthesize defaultConfiguration;
	@synthesize hasContext;
	@synthesize notificationEnabled;
	@synthesize fileURL;

	#pragma mark Model Path Loading

	+(NSString *) filePathForModelNamed:(NSString *)modelName {
		NSString * path = nil;
		NSArray * allBundles = [NSBundle allBundles];
		for (NSBundle * currentBundle in allBundles) {
			path = [currentBundle pathForResource:modelName ofType:@"mom"];
			if (nil != path) {
				break;
			}
		}
		if (nil == path) {
			@throw [NSException exceptionWithName:@"MissingResourceException" reason:[NSString stringWithFormat:@"Can't find model %@!", modelName] userInfo:nil];
		}
		return path;
	}

	+(NSURL *) fileURLForModelNamed:(NSString *)modelName {
		return ([NSURL fileURLWithPath:[UXManagedModel filePathForModelNamed:modelName]]);
	}

	+(UXManagedModel *) managedObjectModelWithName:(NSString *)modelName {
		return [[UXManagedModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[UXManagedModel filePathForModelNamed:modelName]]];
	}


	#pragma mark Initializer

	-(id) init {
		self = [super init];
		if (!self) {
			return nil;
		}
		self.hasContext = NO;
		self.notificationEnabled = NO;
		self.fileURL = nil;
		return self;
	}

	-(void) dealloc {
		[name release]; name = nil;
		[defaultConfiguration release]; defaultConfiguration = nil;
		[fileURL release]; fileURL = nil;
		[super dealloc];
	}

@end