
/*!
@project	UXKit
@header     UXURLMap.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

@class UXURLNavigatorPattern;

/*!
@enum UXNavigationMode
@abstract
@constant 	UXNavigationModeNone,
@constant 	UXNavigationModeCreate	New view controller is created each time
@constant 	UXNavigationModeShare		New view controller is created, cached and re-used
@constant 	UXNavigationModeModal		New view controller is created and presented modally
@constant 	UXNavigationModeExternal  An external app will be opened
*/
typedef enum {
	UXNavigationModeNone,
	UXNavigationModeCreate,
	UXNavigationModeShare,
	UXNavigationModeModal,
	UXNavigationModeExternal,
} UXNavigationMode;

#pragma mark -

/*!
@class UXURLMap
@superclass NSObject
@abstract
@discussion
*/
@interface UXURLMap : NSObject {
	NSMutableDictionary *_objectMappings;
	NSMutableArray *_objectPatterns;
	NSMutableArray *_fragmentPatterns;
	NSMutableDictionary *_stringPatterns;
	NSMutableDictionary *_schemes;
	UXURLNavigatorPattern *_defaultObjectPattern;
	UXURLNavigatorPattern *_hashPattern;
	BOOL _invalidPatterns;
}

	/*!
	@abstract Adds a URL pattern which will perform a selector on an object when loaded.
	*/
	-(void) from:(NSString *)aURL toObject:(id)anObject;
	-(void) from:(NSString *)aURL toObject:(id)anObject selector:(SEL)aSelector;


	#pragma mark View Controllers

	/*!
	@abstract Adds a URL pattern which will create and present a view controller when loaded.
	@discussion The selector will be called on the view controller after is created, and arguments from
	the URL will be extracted using the pattern and passed to the selector.
	@param target	Can be either a Class which is a subclass of UIViewController, or an object which
					implements a method that returns a UIViewController instance.
	@param selector	If you use an object, the selector will be called with arguments extracted from 
					the URL, and the view controller that you return will be the one that is presented.
	*/
	-(void) from:(NSString *)aURL toViewController:(id)aTarget;
	-(void) from:(NSString *)aURL toViewController:(id)aTarget selector:(SEL)aSelector;
	-(void) from:(NSString *)aURL toViewController:(id)aTarget transition:(NSInteger)aTransition;
	-(void) from:(NSString *)aURL parent:(NSString *)aParentURL toViewController:(id)aTarget selector:(SEL)aSelector 
																						   transition:(NSInteger)aTransition;

	#pragma mark Shared View Controllers

	/*!
	@abstract Adds a URL pattern which will create and present a share view controller when loaded.
	@discussion Controllers created with the "share" mode, meaning that it will be created once and re-used
	until it is destroyed.
	*/
	-(void) from:(NSString *)aURL toSharedViewController:(id)aTarget;
	-(void) from:(NSString *)aURL toSharedViewController:(id)aTarget selector:(SEL)aSelector;
	-(void) from:(NSString *)aURL parent:(NSString *)aParentURL toSharedViewController:(id)aTarget;
	-(void) from:(NSString *)aURL parent:(NSString *)aParentURL toSharedViewController:(id)aTarget selector:(SEL)aSelector;

	
	#pragma mark Modal View Controllers

	/*!
	@abstract Adds a URL pattern which will create and present a modal view controller when loaded.
	*/
	-(void) from:(NSString *)aURL toModalViewController:(id)aTarget;
	-(void) from:(NSString *)aURL toModalViewController:(id)aTarget selector:(SEL)aSelector;
	-(void) from:(NSString *)aURL toModalViewController:(id)aTarget transition:(NSInteger)aTransition;
	-(void) from:(NSString *)aURL parent:(NSString *)aParentURL toModalViewController:(id)aTarget selector:(SEL)aSelector 
																								transition:(NSInteger)aTransition;

	#pragma mark -

	/*!
	@abstract Adds a mapping from a class to a generated URL.
	*/
	-(void) from:(Class)aClass toURL:(NSString *)aURL;

	/*!
	@abstract Adds a mapping from a class and a special name to a generated URL.
	*/
	-(void) from:(Class)aClass name:(NSString *)aName toURL:(NSString *)aURL;

	/*!
	@abstract Adds a direct mapping from a literal URL to an object.
	@discussion The URL must not be a pattern - it must be the a literal URL. All requests to 
	open this URL will return the object bound to it, rather than going through the pattern matching 
	process to create a new object. Mapped objects are not retained.  You are responsible for removing 
	the mapping when the object is destroyed, or risk crashes.
	*/
	-(void) setObject:(id)anObject forURL:(NSString *)aURL;

	/*!
	@abstract Removes all objects and patterns mapped to a URL.
	*/
	-(void) removeURL:(NSString *)aURL;

	/*!
	@abstract Removes all URLs bound to an object.
	*/
	-(void) removeObject:(id)anObject;

	/*!
	@abstract Removes objects bound literally to the URL.
	*/
	-(void) removeObjectForURL:(NSString *)aURL;

	/*!
	@abstract Removes all bound objects;
	*/
	-(void) removeAllObjects;


	/*!
	@abstract Gets or creates the object with a pattern that matches the URL.
	@discussion Object mappings are checked first, and if no object is bound to 
	the URL then pattern matching is used to create a new object.
	*/
	-(id) objectForURL:(NSString *)aURL;
	-(id) objectForURL:(NSString *)aURL query:(NSDictionary *)aQuery;
	-(id) objectForURL:(NSString *)aURL query:(NSDictionary *)aQuery pattern:(UXURLNavigatorPattern **)aPattern;

	/*!
	@abstract
	*/
	-(id) dispatchURL:(NSString *)aURL toTarget:(id)aTarget query:(NSDictionary *)aQuery;

	/*!
	@abstract Tests if there is a pattern that matches the URL and if so returns its navigation mode.
	*/
	-(UXNavigationMode) navigationModeForURL:(NSString *)aURL;

	/*!
	@abstract Tests if there is a pattern that matches the URL and if so returns its transition.
	*/
	-(NSInteger) transitionForURL:(NSString *)aURL;

	#pragma mark -

	/*!
	@abstract Returns YES if there is a registered pattern with the URL scheme.
	 */
	-(BOOL) isSchemeSupported:(NSString *)aScheme;

	/*!
	@abstract Returns YES if the URL is destined for an external app.
	 */
	-(BOOL) isAppURL:(NSURL *)aURL;

	/*!
	@abstract Gets a URL that has been mapped to the object.
	*/
	-(NSString *) URLForObject:(id)object;
	-(NSString *) URLForObject:(id)object withName:(NSString *)aName;

@end

#pragma mark -

/*!
@protocol UXURLObject <NSObject>
@abstract
*/
@protocol UXURLObject <NSObject>

@optional
	/*!
	@abstract Converts the object to a URL using UXURLMap.
	*/
	@property (nonatomic, readonly) NSString *URLValue;

	/*!
	@abstract Converts the object to a specially-named URL using UXURLMap.
	*/
	-(NSString *) URLValueWithName:(NSString *)name;

@end
