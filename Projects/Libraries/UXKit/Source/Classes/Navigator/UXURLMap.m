
#import <UXKit/UXURLMap.h>
#import <UXKit/UXURLPattern.h>
#import <objc/runtime.h>

@implementation UXURLMap

	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			_objectMappings			= nil;
			_objectPatterns			= nil;
			_fragmentPatterns		= nil;
			_stringPatterns			= nil;
			_schemes				= nil;
			_defaultObjectPattern	= nil;
			_invalidPatterns		= NO;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_objectMappings);
		UX_SAFE_RELEASE(_objectPatterns);
		UX_SAFE_RELEASE(_fragmentPatterns);
		UX_SAFE_RELEASE(_stringPatterns);
		UX_SAFE_RELEASE(_schemes);
		UX_SAFE_RELEASE(_defaultObjectPattern);
		[super dealloc];
	}


	#pragma mark Internal

	-(NSString *) keyForClass:(Class)cls withName:(NSString *)name {
		const char *className = class_getName(cls);
		return [NSString stringWithFormat:@"%s_%@", className, name ? name:@""];
	}

	-(void) registerScheme:(NSString *)scheme {
		if (scheme) {
			if (!_schemes) {
				_schemes = [[NSMutableDictionary alloc] init];
			}
			[_schemes setObject:[NSNull null] forKey:scheme];
		}
	}

	-(void) addObjectPattern:(UXURLNavigatorPattern *)pattern forURL:(NSString *)URL {
		pattern.URL = URL;
		[pattern compile];
		[self registerScheme:pattern.scheme];
		
		if (pattern.isUniversal) {
			[_defaultObjectPattern release];
			_defaultObjectPattern = [pattern retain];
		}
		else if (pattern.isFragment) {
			if (!_fragmentPatterns) {
				_fragmentPatterns = [[NSMutableArray alloc] init];
			}
			[_fragmentPatterns addObject:pattern];
		}
		else {
			_invalidPatterns = YES;
			
			if (!_objectPatterns) {
				_objectPatterns = [[NSMutableArray alloc] init];
			}
			[_objectPatterns addObject:pattern];
		}
	}

	-(void) addStringPattern:(UXURLGeneratorPattern *)pattern forURL:(NSString *)URL withName:(NSString *)name {
		pattern.URL = URL;
		[pattern compile];
		[self registerScheme:pattern.scheme];
		
		if (!_stringPatterns) {
			_stringPatterns = [[NSMutableDictionary alloc] init];
		}
		
		NSString *key = [self keyForClass:pattern.targetClass withName:name];
		[_stringPatterns setObject:pattern forKey:key];
	}

	-(UXURLNavigatorPattern *) matchObjectPattern:(NSURL *)URL {
		if (_invalidPatterns) {
			[_objectPatterns sortUsingSelector:@selector(compareSpecificity:)];
			_invalidPatterns = NO;
		}
		
		for (UXURLNavigatorPattern *pattern in _objectPatterns) {
			if ([pattern matchURL:URL]) {
				return pattern;
			}
		}
		return _defaultObjectPattern;
	}

	-(BOOL) isWebURL:(NSURL *)URL {
		return [URL.scheme caseInsensitiveCompare:@"http"]		== NSOrderedSame
			   || [URL.scheme caseInsensitiveCompare:@"https"]	== NSOrderedSame
			   || [URL.scheme caseInsensitiveCompare:@"ftp"]	== NSOrderedSame
			   || [URL.scheme caseInsensitiveCompare:@"ftps"]	== NSOrderedSame
			   || [URL.scheme caseInsensitiveCompare:@"data"]	== NSOrderedSame;
		
	}

	-(BOOL) isExternalURL:(NSURL *)URL {
		if ([URL.host isEqualToString:@"maps.google.com"]
			|| [URL.host isEqualToString:@"itunes.apple.com"]
			|| [URL.host isEqualToString:@"phobos.apple.com"]) {
			return YES;
		}
		else {
			return NO;
		}
	}


	#pragma mark API

	-(void) from:(NSString *)URL toObject:(id)target {
		UXURLNavigatorPattern *pattern = [[UXURLNavigatorPattern alloc] initWithTarget:target];
		[self addObjectPattern:pattern forURL:URL];
		[pattern release];
	}

	-(void) from:(NSString *)URL toObject:(id)target selector:(SEL)selector {
		UXURLNavigatorPattern *pattern = [[UXURLNavigatorPattern alloc] initWithTarget:target];
		pattern.selector = selector;
		[self addObjectPattern:pattern forURL:URL];
		[pattern release];
	}

	-(void) from:(NSString *)URL toViewController:(id)target {
		UXURLNavigatorPattern *pattern = [[UXURLNavigatorPattern alloc] initWithTarget:target mode:UXNavigationModeCreate];
		[self addObjectPattern:pattern forURL:URL];
		[pattern release];
	}

	-(void) from:(NSString *)URL toViewController:(id)target selector:(SEL)selector {
		UXURLNavigatorPattern *pattern = [[UXURLNavigatorPattern alloc] initWithTarget:target mode:UXNavigationModeCreate];
		pattern.selector = selector;
		[self addObjectPattern:pattern forURL:URL];
		[pattern release];
	}

	-(void) from:(NSString *)URL toViewController:(id)target transition:(NSInteger)transition {
		UXURLNavigatorPattern *pattern = [[UXURLNavigatorPattern alloc] initWithTarget:target mode:UXNavigationModeCreate];
		pattern.transition = transition;
		[self addObjectPattern:pattern forURL:URL];
		[pattern release];
	}

	-(void) from:(NSString *)URL parent:(NSString *)parentURL toViewController:(id)target selector:(SEL)selector transition:(NSInteger)transition {
		UXURLNavigatorPattern *pattern = [[UXURLNavigatorPattern alloc] initWithTarget:target mode:UXNavigationModeCreate];
		pattern.parentURL = parentURL;
		pattern.selector = selector;
		pattern.transition = transition;
		[self addObjectPattern:pattern forURL:URL];
		[pattern release];
	}

	-(void) from:(NSString *)URL toSharedViewController:(id)target {
		UXURLNavigatorPattern *pattern = [[UXURLNavigatorPattern alloc] initWithTarget:target mode:UXNavigationModeShare];
		[self addObjectPattern:pattern forURL:URL];
		[pattern release];
	}

	-(void) from:(NSString *)URL toSharedViewController:(id)target selector:(SEL)selector {
		UXURLNavigatorPattern *pattern = [[UXURLNavigatorPattern alloc] initWithTarget:target mode:UXNavigationModeShare];
		pattern.selector = selector;
		[self addObjectPattern:pattern forURL:URL];
		[pattern release];
	}

	-(void) from:(NSString *)URL parent:(NSString *)parentURL toSharedViewController:(id)target {
		UXURLNavigatorPattern *pattern = [[UXURLNavigatorPattern alloc] initWithTarget:target mode:UXNavigationModeShare];
		[self addObjectPattern:pattern forURL:URL];
		[pattern release];
	}

	-(void) from:(NSString *)URL parent:(NSString *)parentURL toSharedViewController:(id)target selector:(SEL)selector {
		UXURLNavigatorPattern *pattern = [[UXURLNavigatorPattern alloc] initWithTarget:target mode:UXNavigationModeShare];
		pattern.parentURL = parentURL;
		pattern.selector = selector;
		[self addObjectPattern:pattern forURL:URL];
		[pattern release];
	}

	-(void) from:(NSString *)URL toModalViewController:(id)target {
		UXURLNavigatorPattern *pattern = [[UXURLNavigatorPattern alloc] initWithTarget:target mode:UXNavigationModeModal];
		[self addObjectPattern:pattern forURL:URL];
		[pattern release];
	}

	-(void) from:(NSString *)URL toModalViewController:(id)target selector:(SEL)selector {
		UXURLNavigatorPattern *pattern = [[UXURLNavigatorPattern alloc] initWithTarget:target mode:UXNavigationModeModal];
		pattern.selector = selector;
		[self addObjectPattern:pattern forURL:URL];
		[pattern release];
	}

	-(void) from:(NSString *)URL toModalViewController:(id)target transition:(NSInteger)transition {
		UXURLNavigatorPattern *pattern = [[UXURLNavigatorPattern alloc] initWithTarget:target mode:UXNavigationModeModal];
		pattern.transition = transition;
		[self addObjectPattern:pattern forURL:URL];
		[pattern release];
	}

	-(void) from:(NSString *)URL parent:(NSString *)parentURL toModalViewController:(id)target selector:(SEL)selector transition:(NSInteger)transition {
		UXURLNavigatorPattern *pattern = [[UXURLNavigatorPattern alloc] initWithTarget:target mode:UXNavigationModeModal];
		pattern.parentURL = parentURL;
		pattern.selector = selector;
		pattern.transition = transition;
		[self addObjectPattern:pattern forURL:URL];
		[pattern release];
	}

	-(void) from:(Class)cls toURL:(NSString *)URL {
		UXURLGeneratorPattern *pattern = [[UXURLGeneratorPattern alloc] initWithTargetClass:cls];
		[self addStringPattern:pattern forURL:URL withName:nil];
		[pattern release];
	}

	-(void) from:(Class)cls name:(NSString *)name toURL:(NSString *)URL {
		UXURLGeneratorPattern *pattern = [[UXURLGeneratorPattern alloc] initWithTargetClass:cls];
		[self addStringPattern:pattern forURL:URL withName:name];
		[pattern release];
	}
	

	#pragma mark -
	
	-(void) setObject:(id)object forURL:(NSString *)URL {
		if (!_objectMappings) {
			_objectMappings = UXCreateNonRetainingDictionary();
		}
		// Normalize the URL first
		[_objectMappings setObject:object forKey:URL];
	}

	-(void) removeURL:(NSString *)URL {
		[_objectMappings removeObjectForKey:URL];
		
		for (UXURLNavigatorPattern *pattern in _objectPatterns) {
			if ([URL isEqualToString:pattern.URL]) {
				[_objectPatterns removeObject:pattern];
				break;
			}
		}
	}

	-(void) removeObject:(id)object {
		// IMPLEMENT ME
	}

	-(void) removeObjectForURL:(NSString *)URL {
		[_objectMappings removeObjectForKey:URL];
	}

	-(void) removeAllObjects {
		UX_SAFE_RELEASE(_objectMappings);
	}

	-(id) objectForURL:(NSString *)URL {
		return [self objectForURL:URL query:nil pattern:nil];
	}

	-(id) objectForURL:(NSString *)URL query:(NSDictionary *)query {
		return [self objectForURL:URL query:query pattern:nil];
	}

	-(id) objectForURL:(NSString *)URL query:(NSDictionary *)query pattern:(UXURLNavigatorPattern * *)outPattern {
		id object = nil;
		if (_objectMappings) {
			object = [_objectMappings objectForKey:URL];
			if (object && !outPattern) {
				return object;
			}
		}
		
		NSURL *theURL = [NSURL URLWithString:URL];
		UXURLNavigatorPattern *pattern  = [self matchObjectPattern:theURL];
		if (pattern) {
			if (!object) {
				object = [pattern createObjectFromURL:theURL query:query];
			}
			if ((pattern.navigationMode == UXNavigationModeShare) && object) {
				[self setObject:object forURL:URL];
			}
			if (outPattern) {
				*outPattern = pattern;
			}
			return object;
		}
		else {
			return nil;
		}
	}


	#pragma mark -

	-(id) dispatchURL:(NSString *)URL toTarget:(id)target query:(NSDictionary *)query {
		NSURL *theURL = [NSURL URLWithString:URL];
		for (UXURLNavigatorPattern *pattern in _fragmentPatterns) {
			if ([pattern matchURL:theURL]) {
				return [pattern invoke:target withURL:theURL query:query];
			}
		}
		
		// If there is no match, check if the fragment points to a method on the target
		if (theURL.fragment) {
			SEL selector = NSSelectorFromString(theURL.fragment);
			if (selector && [target respondsToSelector:selector]) {
				[target performSelector:selector];
			}
		}
		return nil;
	}

	-(UXNavigationMode) navigationModeForURL:(NSString *)URL {
		NSURL *theURL = [NSURL URLWithString:URL];
		if (![self isAppURL:theURL]) {
			UXURLNavigatorPattern *pattern = [self matchObjectPattern:theURL];
			if (pattern) {
				return pattern.navigationMode;
			}
		}
		return UXNavigationModeExternal;
	}

	-(NSInteger) transitionForURL:(NSString *)URL {
		UXURLNavigatorPattern *pattern = [self matchObjectPattern:[NSURL URLWithString:URL]];
		return pattern.transition;
	}

	-(BOOL) isSchemeSupported:(NSString *)aScheme {
		return aScheme && !![_schemes objectForKey:aScheme];
	}

	-(BOOL) isAppURL:(NSURL *)aURL {
		return [self isExternalURL:aURL] || ([[UIApplication sharedApplication] canOpenURL:aURL] && ![self isSchemeSupported:aURL.scheme] && ![self isWebURL:aURL]);
	}


	-(NSString *) URLForObject:(id)anObject {
		return [self URLForObject:anObject withName:nil];
	}

	-(NSString *) URLForObject:(id)anObject withName:(NSString *)aName {
		Class cls = [anObject class ] == anObject ? anObject : [anObject class ];
		while (cls) {
			NSString *key = [self keyForClass:cls withName:aName];
			UXURLGeneratorPattern *pattern = [_stringPatterns objectForKey:key];
			if (pattern) {
				return [pattern generateURLFromObject:anObject];
			}
			else {
				cls = class_getSuperclass(cls);
			}
		}
		return nil;
	}

@end
