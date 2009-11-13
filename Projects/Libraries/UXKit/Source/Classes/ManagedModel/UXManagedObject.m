
#import <UXKit/UXManagedObject.h>

@interface UXManagedObject ()

@end

#pragma mark -

@implementation UXManagedObject

	#pragma mark -
	
	+(NSString *) entityPrefix {
		return ([NSString stringWithString:@"UX"]);
	}
	
	+(NSString *) entityName {
		NSString * result = NSStringFromClass([self class]);
		if ([result hasPrefix:[[self class] entityPrefix]]) {
			result = [result substringFromIndex:([[[self class] entityPrefix] length] - 1)];
		}
		return result;
	}

	+(NSEntityDescription *) entityDescriptionInManagedObjectContext:(NSManagedObjectContext *)aContext {
		NSEntityDescription * result = [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:aContext];
		if (nil == result) {
			NSString *className = NSStringFromClass([self class]);
			NSManagedObjectModel *managedObjectModel = [[aContext persistentStoreCoordinator] managedObjectModel];
			for (NSEntityDescription * entityDescription in managedObjectModel) {
				if ([[entityDescription managedObjectClassName] isEqualToString:className]) {
					return entityDescription;
				}
			}
		}
		return result;
	}

	#pragma mark -
	
	-(id) initAndInsertIntoManagedObjectContext:(NSManagedObjectContext *)aContext {
		NSString *entityName  = [[[self class] entityDescriptionInManagedObjectContext:aContext] name];
		return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:aContext];
	}


	#pragma mark -

	/*!
	Method to return a copy of the current object saved in the specified store using the specified context. 
	(This is used to copy an object from one store to another.)  This implementation returns nothing, as subclasses 
	must override to implement the specifics of their copying requirements (for example, if they must copy shallow 
	or deep, use existing objects or create new ones, etc.)
	*/
	-(UXManagedObject *) copyToContext:(NSManagedObjectContext *)context andStore:(NSPersistentStore *)store {
		return nil;
	}


	#pragma mark Undefined Key Logging

	-(void) setValue:(id)aValue forUndefinedKey:(NSString *)aKey {
		UXLOG(@"Value = %@ Undefined Key = %@]", aValue, aKey);
		[super setValue:aValue forUndefinedKey:aKey];
	}

	-(id) valueForUndefinedKey:(NSString *)aKey {
		UXLOG(@"Value for Undefined Key = %@", aKey);
		return [super valueForUndefinedKey:aKey];
	}

@end
