
/*!
@project	UXKit
@header     UXURLPattern.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXURLMap.h>

@protocol UXURLPatternText;

/*!
@class UXURLPattern
@superclass NSObject
@abstract
@discussion
*/
@interface UXURLPattern : NSObject {
	NSString *_URL;
	NSString *_scheme;
	NSMutableArray *_path;
	NSMutableDictionary *_query;
	id <UXURLPatternText> _fragment;
	NSInteger _specificity;
	SEL _selector;
}

	@property (nonatomic, copy) NSString *URL;
	@property (nonatomic, readonly) NSString *scheme;
	@property (nonatomic, readonly) NSInteger specificity;
	@property (nonatomic, readonly) Class classForInvocation;
	@property (nonatomic) SEL selector;

	-(void) setSelectorIfPossible:(SEL)aSelector;

	-(void) compileURL;

@end

#pragma mark -

/*!
@class UXURLNavigatorPattern
@superclass UXURLPattern
@abstract
@discussion
*/
@interface UXURLNavigatorPattern : UXURLPattern {
	Class _targetClass;
	id _targetObject;
	UXNavigationMode _navigationMode;
	NSString *_parentURL;
	NSInteger _transition;
	NSInteger _argumentCount;
}

	@property (nonatomic) Class targetClass;
	@property (nonatomic, assign) id targetObject;
	@property (nonatomic, readonly) UXNavigationMode navigationMode;
	@property (nonatomic, copy) NSString *parentURL;
	@property (nonatomic) NSInteger transition;
	@property (nonatomic) NSInteger argumentCount;
	@property (nonatomic, readonly) BOOL isUniversal;
	@property (nonatomic, readonly) BOOL isFragment;

	-(id) initWithTarget:(id)aTarget;
	-(id) initWithTarget:(id)aTarget mode:(UXNavigationMode)aNavigationMode;

	-(void) compile;

	-(BOOL) matchURL:(NSURL *)aURL;

	-(id) invoke:(id)target withURL:(NSURL *)aURL query:(NSDictionary *)aQuery;
	-(id) createObjectFromURL:(NSURL *)aURL query:(NSDictionary *)aQuery;

@end

#pragma mark -

/*!
@class UXURLGeneratorPattern
@superclass UXURLPattern
@abstract
@discussion
*/
@interface UXURLGeneratorPattern : UXURLPattern {
	Class _targetClass;
}

	@property (nonatomic) Class targetClass;

	-(id) initWithTargetClass:(Class)aTargetClass;

	-(void) compile;
	-(NSString *) generateURLFromObject:(id)object;

@end
