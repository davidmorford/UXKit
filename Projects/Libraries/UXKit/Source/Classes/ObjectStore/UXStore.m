
#import <UXKit/UXStore.h>

@interface UXStore ()
	@property (nonatomic, retain, readwrite) NSSet *managedObjectContexts;
@end

#pragma mark -

@implementation UXStore

	@synthesize delegate;
	@synthesize storeURL;
	@synthesize storeIdentifier;

	@synthesize managedObjectModel;
	@synthesize managedObjectContexts;

	@synthesize persistentStoreCoordinator;
	@synthesize fetchOperationQueue;


	#pragma mark Initializers

	-(id) init {
		self = [super init];
		if (self) {
			notificationCenter		= [[NSNotificationCenter alloc] init];
			fetchOperationQueue		= [[NSOperationQueue alloc] init];
			managedObjectContexts	= [[NSMutableSet alloc] init];
		}
		return self;
	}

	-(id) initWithManagedObjectModel:(NSManagedObjectModel *)aModel storeDirectoryURL:(NSURL *)aURL setup:(BOOL)flag {
		self = [self init];
		if (self) {
			self.managedObjectModel = [aModel copy];
			if (aURL != nil) {
				self.storeURL = [aURL copy];
			}
			if (flag) {
				[self storeCanMergeManagedObjectModels];
				[self storeWillCreatePersistentStoreCoordinator];
				[self storeCanAddPersistentStores];
				[self storeCanCreateManagedObjectContexts];
			}
		}
		return self;
	}


	#pragma mark Setup

	-(void) storeCanMergeManagedObjectModels {
		if (delegate) {
			if ([delegate respondsToSelector:@selector(storeCanMergeManagedObjectModels:)]) {
				[delegate storeCanMergeManagedObjectModels:self];
			}
		}	
	}

	-(void) storeWillCreatePersistentStoreCoordinator {
		if (delegate) {
			if ([delegate respondsToSelector:@selector(storeWillCreatePersistentStoreCoordinator:)]) {
				[delegate storeWillCreatePersistentStoreCoordinator:self];
			}
		}
		self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];	
	}

	-(void) storeCanAddPersistentStores {
		if (delegate) {
			if ([delegate respondsToSelector:@selector(storeCanAddPersistentStores:)]) {
				[delegate storeCanAddPersistentStores:self];
			}
		}
		
		if (self.storeURL != nil) {
			[self addStoreWithIdentifier:@"Store" storeType:NSSQLiteStoreType forModelConfiguration:nil];
		}
		else {
			[self addStoreWithIdentifier:@"Store" storeType:NSInMemoryStoreType forModelConfiguration:nil];
		}
	}

	-(void) storeCanCreateManagedObjectContexts {
		if (delegate) {
			if ([delegate respondsToSelector:@selector(storeCanCreateManagedObjectContexts:)]) {
				[delegate storeCanCreateManagedObjectContexts:self];
			}
		}
		
		UXObjectStoreContext *context = (UXObjectStoreContext *)[self newManagedObjectContextWithIdentifier:@"Default"];
		[context save:nil];
	}


	#pragma mark Models

	-(void) addModel:(NSManagedObjectModel *)anObjectModel {
		self.managedObjectModel = [NSManagedObjectModel modelByMergingModels:[NSArray arrayWithObject:anObjectModel]];
	}

	-(void) addModels:(NSArray *)aModelArray {
		self.managedObjectModel = [NSManagedObjectModel modelByMergingModels:aModelArray];
	}


	#pragma mark Fetch Request Templates

	-(NSArray *) fetchRequestTemplateNames {
		return ([[[self.managedObjectModel fetchRequestTemplatesByName] allKeys] copy]);
	}

	-(NSFetchRequest *) fetchRequestTemplateForName:(NSString *)aName {
		return ([self.managedObjectModel fetchRequestTemplateForName:aName]);
	}

	-(NSFetchRequest *) fetchRequestFromTemplateWithName:(NSString *)aName substitutionVariables:(NSDictionary *)variables {
		return ([self.managedObjectModel fetchRequestFromTemplateWithName:aName substitutionVariables:variables]);
	}


	#pragma mark Stores

	-(NSArray *) persistentStores {
		return ([self.persistentStoreCoordinator persistentStores]);
	}

	-(NSPersistentStore *) persistentStoreForConfigurationName:(NSString *)aConfigurationName {
		for (NSPersistentStore * store in self.persistentStores) {
			if ([[store configurationName] compare:aConfigurationName] == NSOrderedSame) {
				return store;
			}
		}
		return nil;
	}

	-(NSPersistentStore *) persistentStoreWithIdentifer:(NSString *)anIdentifer {
		for (NSPersistentStore * store in self.persistentStores) {
			if ([[store identifier] compare:anIdentifer] == NSOrderedSame) {
				return store;
			}
		}
		return nil;
	}

	-(NSPersistentStore *) addStoreWithIdentifier:(NSString *)aStoreName storeType:(NSString *)aStoreType forModelConfiguration:(NSString *)aModelConfiguration {
		NSPersistentStore * persistentStore;
		NSError * storeSetupError;		
		NSString * storeExtension;
		
		if (aStoreType == NSBinaryStoreType) {
			storeExtension = @"store";
		}
		/*
		#ifdef 
		else if (aStoreType == NSXMLStoreType) {
			storeExtension = @"xmlStore";
		}*/
		else if (aStoreType == NSSQLiteStoreType) {
			storeExtension = @"sqliteStore";
		}
				
		NSString *persistentStoreFileName	= [NSString stringWithFormat:@"%@.%@", aStoreName, storeExtension];
		NSURL *persistentStoreFileURL		= [NSURL fileURLWithPath:[[self.storeURL path] stringByAppendingPathComponent:persistentStoreFileName]];
		
		if (![[NSFileManager defaultManager] fileExistsAtPath:[persistentStoreFileURL path] isDirectory:NO]) {
			[[NSFileManager defaultManager] createDirectoryAtPath:[self.storeURL path] attributes:nil];
		}		
		
		if ([aStoreType compare:NSInMemoryStoreType options:NSCaseInsensitiveSearch] == NSOrderedSame) {
			persistentStore = [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType 
																	   configuration:aModelConfiguration 
																				 URL:nil 
																			 options:nil 
																			   error:&storeSetupError];
		}
		else if ([aStoreType compare:NSBinaryStoreType options:NSCaseInsensitiveSearch] == NSOrderedSame) {
			persistentStore	= [persistentStoreCoordinator addPersistentStoreWithType:NSBinaryStoreType
																	   configuration:aModelConfiguration 
																				 URL:persistentStoreFileURL
																			 options:nil 
																			   error:&storeSetupError];
		}
		/*else if ([aStoreType compare:NSXMLStoreType options:NSCaseInsensitiveSearch] == NSOrderedSame) {
			persistentStore	= [persistentStoreCoordinator addPersistentStoreWithType:NSXMLStoreType 
																	   configuration:aModelConfiguration 
																				 URL:persistentStoreFileURL
																			 options:nil 
																			   error:&storeSetupError];
		}*/
		else if ([aStoreType compare:NSSQLiteStoreType options:NSCaseInsensitiveSearch] == NSOrderedSame) {
			NSMutableDictionary * pragmaOptions = [NSMutableDictionary dictionary];
			[pragmaOptions setObject:@"OFF" forKey:@"synchronous"];
			[pragmaOptions setObject:@"0" forKey:@"fullfsync"];
			
			NSDictionary *storeOptions = [NSDictionary dictionaryWithObject:pragmaOptions forKey:NSSQLitePragmasOption];
			persistentStore = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType 
																	   configuration:aModelConfiguration 
																				 URL:persistentStoreFileURL
																			 options:storeOptions
																			   error:&storeSetupError];
		}
		
		if (!persistentStore) {
			return nil;
		}
		
		[persistentStore setIdentifier:aStoreName];
		return persistentStore;
	}


	#pragma mark Contexts

	-(NSSet *) managedObjectContexts {
		return [NSSet setWithSet:managedObjectContexts];
	}

	-(id <UXStoreContext>) newManagedObjectContextWithIdentifier:(NSString *)anIdentifier {
		UXObjectStoreContext *context = [[UXObjectStoreContext alloc] initWithIdentifier:anIdentifier 
																   persistentStoreCoordinator:self.persistentStoreCoordinator];
		[self addManagedObjectContext:context];
		return context;
	}

	-(id <UXStoreContext>) managedObjectContextWithIdentifier:(NSString *)anIdentifier {
		NSSet *contexts = [NSSet setWithSet:managedObjectContexts];
		for (UXObjectStoreContext *context in contexts) {
			if ([context.identifier compare:anIdentifier] == NSOrderedSame) {
				return context;
			}
		}
		return nil;
	}

	-(void) addManagedObjectContext:(NSManagedObjectContext *)aManagedObjectContext {
		if (![aManagedObjectContext persistentStoreCoordinator]) {
			[aManagedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
		}
		
		[managedObjectContexts addObject:aManagedObjectContext];
		
		[notificationCenter addObserver:self selector:@selector(contextObjectsDidChangeNotification:) name:NSManagedObjectContextObjectsDidChangeNotification object:aManagedObjectContext];
		[notificationCenter addObserver:self selector:@selector(contextDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:aManagedObjectContext];
	}

	-(void) removeManagedObjectObject:(NSManagedObjectContext *)aManagedObjectContext {
		if ([managedObjectContexts containsObject:aManagedObjectContext]) {
			[notificationCenter removeObserver:self name:NSManagedObjectContextObjectsDidChangeNotification object:aManagedObjectContext];
			[notificationCenter removeObserver:self name:NSManagedObjectContextDidSaveNotification object:aManagedObjectContext];
			[managedObjectContexts removeObject:aManagedObjectContext];
		}
	}

	-(BOOL) saveContexts {
		for (NSManagedObjectContext * context in managedObjectContexts) {
			[context processPendingChanges];
		}
		
		NSError *error = nil;
		BOOL saved = NO;
		
		for (NSManagedObjectContext *context in managedObjectContexts) {
			[context save:&error];
			if (!error) {
				saved = YES;
			}
		}
		return saved;
	}

	-(BOOL) saveContextWithIdentifier:(NSString *)aName {
		UXObjectStoreContext *context = (UXObjectStoreContext *)[self managedObjectContextWithIdentifier:aName];
		NSError * error = nil;
		BOOL saved = NO;
		
		if (context) {
			[context processPendingChanges];
			[context save:&error];
		}
		return saved;
	}	


	#pragma mark Managed Objects

	-(NSEntityDescription *) entityForObjectID:(NSManagedObjectID *)anObjectID {
		return ([anObjectID entity]);
	}	

	-(NSManagedObjectID *) managedObjectIDForURI:(NSURL *)anObjectURI {
		return [self.persistentStoreCoordinator managedObjectIDForURIRepresentation:anObjectURI];
	}

	-(NSManagedObject *) managedObjectForURI:(NSURL *)anObjectURI {
		return nil;
	}

	-(NSPersistentStore *) persistentStoreForObjectID:(NSManagedObjectID *)anObjectID {
		return ([anObjectID persistentStore]);
	}


	#pragma mark Fetch Request

	-(NSArray *) executeFetchRequest:(NSFetchRequest *)request withManagedObjectContext:(NSManagedObjectContext *)aContext {
		NSError * fetchError = nil;
		NSArray * fetchResults;
		
		fetchResults = [aContext executeFetchRequest:request error:&fetchError];
		
		if (fetchError) {
			return nil;
		}
		return fetchResults;
	}

	-(NSArray *) executeFetchRequestWithName:(NSString *)aName withManagedObjectContext:(NSManagedObjectContext *)aContext {
		NSFetchRequest * fetchRequest = [self fetchRequestTemplateForName:aName];
		NSArray * fetchResults;
		
		fetchResults = [self executeFetchRequest:fetchRequest withManagedObjectContext:aContext];
		
		return fetchResults;
	}


	#pragma mark Entity Fetch Requests

	-(NSArray *) objectsWithEntityName:(NSString *)anEntityName inManagedObjectContext:(NSManagedObjectContext *)aContext {
		NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
		NSArray * fetchResults;
		
		[fetchRequest setEntity:[NSEntityDescription entityForName:anEntityName inManagedObjectContext:aContext]];
		fetchResults = [self executeFetchRequest:fetchRequest withManagedObjectContext:aContext];
				
		return fetchResults;
	}

	-(NSArray *) objectsWithEntityName:(NSString *)anEntityName inManagedObjectContext:(NSManagedObjectContext *)aContext matchingPredicate:(NSPredicate *)aPredicate {
		return [self objectsWithEntityName:anEntityName inManagedObjectContext:aContext matchingPredicate:aPredicate sortedBy:nil];
	}

	-(NSArray *) objectsWithEntityName:(NSString *)anEntityName inManagedObjectContext:(NSManagedObjectContext *)aContext matchingPredicate:(NSPredicate *)aPredicate sortedBy:(NSSortDescriptor *)aSortDescriptor {
		NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
		NSArray * fetchResults;
		
		[fetchRequest setEntity:[NSEntityDescription entityForName:anEntityName inManagedObjectContext:aContext]];
		[fetchRequest setPredicate:aPredicate];
		
		if (aSortDescriptor) {
			[fetchRequest setSortDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
		}
				
		fetchResults = [self executeFetchRequest:fetchRequest withManagedObjectContext:aContext];
		
		return fetchResults;
	}


	#pragma mark Object ID Fetch Requests

	-(NSArray *) objectIDsWithEntityName:(NSString *)anEntityName inManagedObjectContext:(NSManagedObjectContext *)aContext matchingPredicate:(NSPredicate *)aPredicate {
		NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
		NSArray * fetchResults;
		
		[fetchRequest setEntity:[NSEntityDescription entityForName:anEntityName inManagedObjectContext:aContext]];
		[fetchRequest setPredicate:aPredicate];
		[fetchRequest setResultType:NSManagedObjectIDResultType];
		
		fetchResults = [self executeFetchRequest:fetchRequest withManagedObjectContext:aContext];
		
		return fetchResults;
	}


	#pragma mark Notifications

	-(void) coordinatorStoresDidChangeNotification:(NSNotification *)aNotification {
		
		//NSDictionary *changeKeys = [aNotification userInfo];
		
		/*
		// An array of stores that were added.
		NSSet *added = [changeKeys objectForKey:NSAddedPersistentStoresKey];
		
		// An array of stores that were removed.
		NSSet *removed = [changeKeys objectForKey:NSRemovedPersistentStoresKey];
		
		// An array of stores whose UUIDs changed.
		NSSet *removed = [changeKeys objectForKey:NSUUIDChangedPersistentStoresKey];
		*/
	}

	-(void) contextObjectsDidChangeNotification:(NSNotification *)aNotification {
		
		//UXManagedObjectContext * context = [aNotification object];
		//NSDictionary * changeKeys = [aNotification userInfo];
		
		/*
		NSSet * updated = [changeKeys objectForKey:NSUpdatedObjectsKey];
		NSSet * inserted = [changeKeys objectForKey:NSInsertedObjectsKey];
		NSSet * deleted = [changeKeys objectForKey:NSDeletedObjectsKey];
		NSSet * refreshed = [changeKeys objectForKey:NSRefreshedObjectsKey];
		NSSet * invalidated = [changeKeys objectForKey:NSInvalidatedObjectsKey];
		NSSet * allInvalidated = [changeKeys objectForKey:NSInvalidatedAllObjectsKey];
		*/
	}

	-(void) contextDidSaveNotification:(NSNotification *)aNotification {

	}

@end

#pragma mark -

@implementation NSString (UXStoreModelNameConversions)

	+(NSString *) externalNameForInternalName:(NSString *)name separatorString:(NSString *)separatorString useAllCaps:(BOOL)useAllCaps {
		NSScanner * scanner;
		NSCharacterSet *upper, *lower;
		NSString * str;
		NSMutableString * external;
		BOOL isFirstChar = YES;
		
		external = [NSMutableString stringWithCapacity:1];
		upper    = [NSCharacterSet uppercaseLetterCharacterSet];
		lower    = [NSCharacterSet lowercaseLetterCharacterSet];
		scanner  = [NSScanner scannerWithString:name];
		
		while ([scanner isAtEnd] == NO) {
			
			if ([scanner scanCharactersFromSet:lower intoString:&str]) {
				if (useAllCaps) {
					[external appendString:[str uppercaseString]];
				} else {
					[external appendString:[str lowercaseString]];
				}
			}
			else if ([scanner scanUpToCharactersFromSet:lower intoString:&str]) {
				if (isFirstChar == NO) [external appendString:separatorString];
				
				if (useAllCaps) {
					[external appendString:[str uppercaseString]];
				} else {
					[external appendString:[str lowercaseString]];
				}
			}
			
			isFirstChar = NO;
		}
		
		return [NSString stringWithString:external];
	}
	
	+(NSString *) nameForExternalName:(NSString *)name separatorString:(NSString *)separatorString initialCaps:(BOOL)initialCaps {
	
		id e, list, obj;
		NSMutableString *beautified;
		
		beautified = [NSMutableString stringWithCapacity:1];
		list = [name componentsSeparatedByString:separatorString];
		e = [list objectEnumerator];
		
		// first word
		obj = [e nextObject];
		obj = [obj lowercaseString];
		
		if (initialCaps == YES)
			obj = [obj capitalizedString];
		
		[beautified appendString:obj];
		
		// other words
		while ((obj = [e nextObject]) != nil) {
			[beautified appendString:[obj capitalizedString]];
		}
		
		return [NSString stringWithString:beautified];
	}

@end
