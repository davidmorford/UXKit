
#import <ControllerKit/UXObjectController.h>

@implementation UXObjectController

	@synthesize content;
	@synthesize objectClass;
	@synthesize isEditing  = editing;
	@synthesize isEditable = editable;


	#pragma mark Initializer

	-(id) init {
		self = [super init];
		if (self) {
			self.objectClass	= [NSMutableDictionary class];
			self.content		= [[NSMutableDictionary alloc] init];
		}
		return self;
	}

	-(id) initWithContent:(id)contentObject {
		self = [super init];
		if (self) {
			self.content		= contentObject;
			self.objectClass	= [self.content class];
			self.isEditing		= FALSE;
			self.isEditable		= TRUE;
		}
		return self;
	}


	#pragma mark -

	-(id) newObject {
		return [[self.objectClass alloc] init];
	}


	#pragma mark <UXController>

	-(void) objectDidBeginEditing:(id)editor {
		
	}

	-(void) objectDidEndEditing:(id)editor {
		
	}


	#pragma mark Memory

	-(void) dealloc {
		[content release]; content = nil;
		[super dealloc];
	}

@end

#pragma mark -

@implementation UXManagedObjectController

	@synthesize managedObjectContext;
	@synthesize entityName;
	@synthesize fetchPredicate;
	@synthesize defaultFetchRequest;

	#pragma mark -

	-(id) init {
		self = [super init];
		if (self != nil) {
			self.objectClass	= [NSManagedObject class];
			self.content		= nil;
		}
		return self;
	}

	-(id) initWithContent:(id)contentObject {
		self = [super initWithContent:contentObject];
		if (self) {
			self.entityName = [[self.content entity] name];
		}
		return self;
	}


	#pragma mark UXObjectController

	-(id) newObject {
		// autoreleased... which sucks. sigh.
		return [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
	}


	#pragma mark <UXController>

	-(void) objectDidBeginEditing:(id)editor {
		[super objectDidBeginEditing:editor];
	}

	-(void) objectDidEndEditing:(id)editor {
		[super objectDidEndEditing:editor];
	}

	#pragma mark -

	-(void) fetch {
	
	}

	/*!
	@abstract subclasses can override this method to customize the fetch request, for example to specify 
	fetch limits (passing nil for the fetch request will result in the default fetch request to be used; 
	this method will never be invoked with a nil fetch request from within the standard Cocoa frameworks) - 
	the merge flag determines whether the controller replaces the entire content with the fetch result or 
	merges the existing content with the fetch result
	*/
	-(BOOL) fetchWithRequest:(NSFetchRequest *)fetchRequest merge:(BOOL)merge error:(NSError **)error {
		return FALSE;
	}

	#pragma mark Memory

	-(void) dealloc {
		[defaultFetchRequest release]; defaultFetchRequest = nil;
		[fetchPredicate release]; fetchPredicate = nil;
		[entityName release]; entityName = nil;
		managedObjectContext = nil;
		[super dealloc];
	}

@end
