
#import <UXKit/UXURLPattern.h>
#import <objc/runtime.h>

static NSString *kUniversalURLPattern = @"*";

typedef NSUInteger UXURLArgumentType;
enum {
	UXURLArgumentTypeNone,
	UXURLArgumentTypePointer,
	UXURLArgumentTypeBool,
	UXURLArgumentTypeInteger,
	UXURLArgumentTypeLongLong,
	UXURLArgumentTypeFloat,
	UXURLArgumentTypeDouble,
};

static UXURLArgumentType
UXConvertArgumentType(char argType) {
	if ((argType == 'c') || (argType == 'i') || (argType == 's') || (argType == 'l') || (argType == 'C') || (argType == 'I') || (argType == 'S') || (argType == 'L') ) {
		return UXURLArgumentTypeInteger;
	}
	else if (argType == 'q' || argType == 'Q') {
		return UXURLArgumentTypeLongLong;
	}
	else if (argType == 'f') {
		return UXURLArgumentTypeFloat;
	}
	else if (argType == 'd') {
		return UXURLArgumentTypeDouble;
	}
	else if (argType == 'B') {
		return UXURLArgumentTypeBool;
	}
	else {
		return UXURLArgumentTypePointer;
	}
}

static UXURLArgumentType
UXURLArgumentTypeForProperty(Class cls, NSString *propertyName) {
	objc_property_t prop = class_getProperty(cls, propertyName.UTF8String);
	if (prop) {
		const char *type = property_getAttributes(prop);
		return UXConvertArgumentType(type[1]);
	}
	else {
		return UXURLArgumentTypeNone;
	}
}

#pragma mark -

@interface UXURLSelector : NSObject {
	NSString *_name;
	SEL _selector;
	UXURLSelector *_next;
}

	@property (nonatomic, readonly) NSString *name;
	@property (nonatomic, retain) UXURLSelector *next;

	-(id) initWithName:(NSString *)aName;

	-(NSString *) perform:(id)anObject returnType:(UXURLArgumentType)aTeturnType;

@end

#pragma mark -

@implementation UXURLSelector

	@synthesize name = _name;
	@synthesize next = _next;

	-(id) initWithName:(NSString *)name {
		if (self = [super init]) {
			_name		= [name copy];
			_selector	= NSSelectorFromString(_name);
			_next		= nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_name);
		UX_SAFE_RELEASE(_next);
		[super dealloc];
	}

	-(NSString *) perform:(id)object returnType:(UXURLArgumentType)returnType {
		if (_next) {
			id value = [object performSelector:_selector];
			return [_next perform:value returnType:returnType];
		}
		else {
			NSMethodSignature *sig		= [object methodSignatureForSelector:_selector];
			NSInvocation *invocation	= [NSInvocation invocationWithMethodSignature:sig];
			[invocation setTarget:object];
			[invocation setSelector:_selector];
			[invocation invoke];
			
			if (!returnType) {
				returnType = UXURLArgumentTypeForProperty([object class ], _name);
			}
			
			switch (returnType) {
				case UXURLArgumentTypeNone: {
					return @"";
				}
				case UXURLArgumentTypeInteger: {
					int val;
					[invocation getReturnValue:&val];
					return [NSString stringWithFormat:@"%d", val];
				}
				case UXURLArgumentTypeLongLong: {
					long long val;
					[invocation getReturnValue:&val];
					return [NSString stringWithFormat:@"%lld", val];
				}
				case UXURLArgumentTypeFloat: {
					float val;
					[invocation getReturnValue:&val];
					return [NSString stringWithFormat:@"%f", val];
				}
				case UXURLArgumentTypeDouble: {
					double val;
					[invocation getReturnValue:&val];
					return [NSString stringWithFormat:@"%f", val];
				}
				case UXURLArgumentTypeBool: {
					BOOL val;
					[invocation getReturnValue:&val];
					return [NSString stringWithFormat:@"%d", val];
				}
				default: {
					id val;
					[invocation getReturnValue:&val];
					return [NSString stringWithFormat:@"%@", val];
				}
			}
			return @"";
		}
	}

@end

#pragma mark -

@protocol UXURLPatternText <NSObject>

	-(BOOL) match:(NSString *)aTextString;

	-(NSString *) convertPropertyOfObject:(id)anObject;

@end

#pragma mark -

@interface UXURLLiteral : NSObject <UXURLPatternText> {
	NSString *_name;
}

	@property (nonatomic, copy) NSString *name;

@end

#pragma mark -

@implementation UXURLLiteral

	@synthesize name = _name;

	#pragma mark <NSObject>

	-(id) init {
		if (self = [super init]) {
			_name = nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_name);
		[super dealloc];
	}


	#pragma mark API

	-(BOOL) match:(NSString *)text {
		return [text isEqualToString:_name];
	}

	-(NSString *) convertPropertyOfObject:(id)object {
		return _name;
	}

@end

#pragma mark -

@interface UXURLWildcard : NSObject <UXURLPatternText> {
	NSString *_name;
	NSInteger _argIndex;
	UXURLArgumentType _argType;
	UXURLSelector *_selector;
}

	@property (nonatomic, copy) NSString *name;
	@property (nonatomic) NSInteger argIndex;
	@property (nonatomic) UXURLArgumentType argType;
	@property (nonatomic, retain) UXURLSelector *selector;

	-(void) deduceSelectorForClass:(Class)cls;

@end

#pragma mark -

@implementation UXURLWildcard

	@synthesize name		= _name;
	@synthesize argIndex	= _argIndex; 
	@synthesize argType		= _argType; 
	@synthesize selector	= _selector;

	#pragma mark <NSObject>

	-(id) init {
		if (self = [super init]) {
			_name = nil;
			_argIndex = NSNotFound;
			_argType = UXURLArgumentTypeNone;
			_selector = nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_name);
		UX_SAFE_RELEASE(_selector);
		[super dealloc];
	}


	#pragma mark API

	-(BOOL) match:(NSString *)text {
		return YES;
	}

	-(NSString *) convertPropertyOfObject:(id)object {
		if (_selector) {
			return [_selector perform:object returnType:_argType];
		}
		else {
			return @"";
		}
	}

	-(void) deduceSelectorForClass:(Class)cls {
		NSArray *names = [_name componentsSeparatedByString:@"."];
		if (names.count > 1) {
			UXURLSelector *selector = nil;
			for (NSString *name in names) {
				UXURLSelector *newSelector = [[[UXURLSelector alloc] initWithName:name] autorelease];
				if (selector) {
					selector.next = newSelector;
				}
				else {
					self.selector = newSelector;
				}
				selector = newSelector;
			}
		}
		else {
			self.argType = UXURLArgumentTypeForProperty(cls, _name);
			self.selector = [[[UXURLSelector alloc] initWithName:_name] autorelease];
		}
	}

@end

#pragma mark -

@implementation UXURLPattern

	@synthesize URL = _URL; 
	@synthesize scheme = _scheme;
	@synthesize specificity = _specificity;
	@synthesize selector = _selector;


	#pragma mark SPI

	-(id <UXURLPatternText>) parseText:(NSString *)text {
		NSInteger len = text.length;
		if ((len >= 2) && ([text characterAtIndex:0] == '(') && ([text characterAtIndex:len - 1] == ')')) {
			NSInteger endRange		= len > 3 && [text characterAtIndex:len - 2] == ':' ? len - 3 : len - 2;
			NSString *name			= len > 2 ? [text substringWithRange:NSMakeRange(1, endRange)] : nil;
			UXURLWildcard *wildcard = [[[UXURLWildcard alloc] init] autorelease];
			wildcard.name			= name;
			++_specificity;
			return wildcard;
		}
		else {
			UXURLLiteral *literal	= [[[UXURLLiteral alloc] init] autorelease];
			literal.name			= text;
			_specificity			+= 2;
			return literal;
		}
	}

	-(void) parsePathComponent:(NSString *)value {
		id <UXURLPatternText> component = [self parseText:value];
		[_path addObject:component];
	}

	-(void) parseParameter:(NSString *)name value:(NSString *)value {
		if (!_query) {
			_query = [[NSMutableDictionary alloc] init];
		}
		
		id <UXURLPatternText> component = [self parseText:value];
		[_query setObject:component forKey:name];
	}

	-(void) setSelectorWithNames:(NSArray *)names {
		NSString *selectorName	= [[names componentsJoinedByString:@":"] stringByAppendingString:@":"];
		SEL selector			= NSSelectorFromString(selectorName);
		[self setSelectorIfPossible:selector];
	}


	#pragma mark <NSObject>

	-(id) init {
		if (self = [super init]) {
			_URL			= nil;
			_scheme			= nil;
			_path			= [[NSMutableArray alloc] init];
			_query			= nil;
			_fragment		= nil;
			_specificity	= 0;
			_selector		= nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_URL);
		UX_SAFE_RELEASE(_scheme);
		UX_SAFE_RELEASE(_path);
		UX_SAFE_RELEASE(_query);
		UX_SAFE_RELEASE(_fragment);
		[super dealloc];
	}


	#pragma mark API

	-(Class) classForInvocation {
		return nil;
	}

	-(void) setSelectorIfPossible:(SEL)selector {
		Class cls = [self classForInvocation];
		if (!cls || class_respondsToSelector(cls, selector) || class_getClassMethod(cls, selector)) {
			_selector = selector;
		}
	}

	-(void) compileURL {
		NSURL *URL	= [NSURL URLWithString:_URL];
		_scheme		= [URL.scheme copy];
		if (URL.host) {
			[self parsePathComponent:URL.host];
			if (URL.path) {
				for (NSString *name in URL.path.pathComponents) {
					if (![name isEqualToString:@"/"]) {
						[self parsePathComponent:name];
					}
				}
			}
		}
		
		if (URL.query) {
			NSDictionary *query = [URL.query queryDictionaryUsingEncoding:NSUTF8StringEncoding];
			for (NSString *name in [query keyEnumerator]) {
				NSString *value = [query objectForKey:name];
				[self parseParameter:name value:value];
			}
		}
		
		if (URL.fragment) {
			_fragment = [[self parseText:URL.fragment] retain];
		}
	}

@end

#pragma mark -

@implementation UXURLNavigatorPattern

	@synthesize targetClass		= _targetClass;
	@synthesize targetObject	= _targetObject;
	@synthesize navigationMode	= _navigationMode;
	@synthesize parentURL		= _parentURL;
	@synthesize transition		= _transition;
	@synthesize argumentCount	= _argumentCount;

	#pragma mark SPI

	-(BOOL) instantiatesClass {
		return _targetClass && _navigationMode;
	}

	-(BOOL) callsInstanceMethod {
		return (_targetObject && [_targetObject class ] != _targetObject) || _targetClass;
	}

	-(NSComparisonResult) compareSpecificity:(UXURLPattern *)pattern2 {
		if (_specificity > pattern2.specificity) {
			return NSOrderedAscending;
		}
		else if (_specificity < pattern2.specificity) {
			return NSOrderedDescending;
		}
		else {
			return NSOrderedSame;
		}
	}

	-(void) deduceSelector {
		NSMutableArray *parts = [NSMutableArray array];
		
		for (id <UXURLPatternText> pattern in _path) {
			if ([pattern isKindOfClass:[UXURLWildcard class ]]) {
				UXURLWildcard *wildcard = (UXURLWildcard *)pattern;
				if (wildcard.name) {
					[parts addObject:wildcard.name];
				}
			}
		}
		
		for (id <UXURLPatternText> pattern in [_query objectEnumerator]) {
			if ([pattern isKindOfClass:[UXURLWildcard class ]]) {
				UXURLWildcard *wildcard = (UXURLWildcard *)pattern;
				if (wildcard.name) {
					[parts addObject:wildcard.name];
				}
			}
		}
		
		if ([_fragment isKindOfClass:[UXURLWildcard class ]]) {
			UXURLWildcard *wildcard = (UXURLWildcard *)_fragment;
			if (wildcard.name) {
				[parts addObject:wildcard.name];
			}
		}
		
		if (parts.count) {
			[self setSelectorWithNames:parts];
			if (!_selector) {
				[parts addObject:@"query"];
				[self setSelectorWithNames:parts];
			}
		}
		else {
			[self setSelectorIfPossible:@selector(initWithNavigatorURL:query:)];
		}
	}

	-(void) analyzeArgument:(id <UXURLPatternText>)pattern method:(Method)method argNames:(NSArray *)argNames {
		if ([pattern isKindOfClass:[UXURLWildcard class ]]) {
			UXURLWildcard *wildcard = (UXURLWildcard *)pattern;
			wildcard.argIndex		= [argNames indexOfObject:wildcard.name];
			if (wildcard.argIndex == NSNotFound) {
				UXWARN(@"Argument %@ not found in @selector(%s)", wildcard.name, sel_getName(_selector));
			}
			else {
				char argType[256];
				method_getArgumentType(method, wildcard.argIndex + 2, argType, 256);
				wildcard.argType = UXConvertArgumentType(argType[0]);
			}
		}
	}

	-(void) analyzeMethod {
		Class cls		= [self classForInvocation];
		Method method	= [self instantiatesClass] ? class_getInstanceMethod(cls, _selector) : class_getClassMethod(cls, _selector);
		if (method) {
			_argumentCount = method_getNumberOfArguments(method) - 2;
			
			// Look up the index and type of each argument in the method
			const char *selName		= sel_getName(_selector);
			NSString *selectorName	= [[NSString alloc] initWithBytesNoCopy:(char *)selName
																	length:strlen(selName)
																  encoding:NSASCIIStringEncoding 
															  freeWhenDone:NO];
			
			NSArray *argNames = [selectorName componentsSeparatedByString:@":"];
			
			for (id <UXURLPatternText> pattern in _path) {
				[self analyzeArgument:pattern method:method argNames:argNames];
			}
			
			for (id <UXURLPatternText> pattern in [_query objectEnumerator]) {
				[self analyzeArgument:pattern method:method argNames:argNames];
			}
			
			if (_fragment) {
				[self analyzeArgument:_fragment method:method argNames:argNames];
			}
			[selectorName release];
		}
	}

	-(void) analyzeProperties {
		Class cls = [self classForInvocation];
		
		for (id <UXURLPatternText> pattern in _path) {
			if ([pattern isKindOfClass:[UXURLWildcard class ]]) {
				UXURLWildcard *wildcard = (UXURLWildcard *)pattern;
				[wildcard deduceSelectorForClass:cls];
			}
		}
		
		for (id <UXURLPatternText> pattern in [_query objectEnumerator]) {
			if ([pattern isKindOfClass:[UXURLWildcard class ]]) {
				UXURLWildcard *wildcard = (UXURLWildcard *)pattern;
				[wildcard deduceSelectorForClass:cls];
			}
		}
	}

	-(BOOL) setArgument:(NSString *)text pattern:(id <UXURLPatternText>)patternText forInvocation:(NSInvocation *)invocation {
		if ([patternText isKindOfClass:[UXURLWildcard class ]]) {
			UXURLWildcard *wildcard = (UXURLWildcard *)patternText;
			NSInteger index			= wildcard.argIndex;
			
			if ((index != NSNotFound) && (index < _argumentCount) ) {
				
				switch (wildcard.argType) {
					
					case UXURLArgumentTypeNone: {
						break;
					}
					case UXURLArgumentTypeInteger: {
						int val = [text intValue];
						[invocation setArgument:&val atIndex:index + 2];
						break;
					}
					case UXURLArgumentTypeLongLong: {
						long long val = [text longLongValue];
						[invocation setArgument:&val atIndex:index + 2];
						break;
					}
					case UXURLArgumentTypeFloat: {
						float val = [text floatValue];
						[invocation setArgument:&val atIndex:index + 2];
						break;
					}
					case UXURLArgumentTypeDouble: {
						double val = [text doubleValue];
						[invocation setArgument:&val atIndex:index + 2];
						break;
					}
					case UXURLArgumentTypeBool: {
						BOOL val = [text boolValue];
						[invocation setArgument:&val atIndex:index + 2];
						break;
					}
					default: {
						[invocation setArgument:&text atIndex:index + 2];
						break;
					}
				}
				return YES;
			}
		}
		return NO;
	}

	-(void) setArgumentsFromURL:(NSURL *)URL forInvocation:(NSInvocation *)invocation query:(NSDictionary *)query {
		NSInteger remainingArgs				= _argumentCount;
		NSMutableDictionary *unmatchedArgs	= query ? [[query mutableCopy] autorelease] : nil;
		NSArray *pathComponents				= URL.path.pathComponents;
		
		for (NSInteger i = 0; i < _path.count; ++i) {
			
			id <UXURLPatternText> patternText = [_path objectAtIndex:i];
			NSString *text = i == 0 ? URL.host : [pathComponents objectAtIndex:i];
			if ([self setArgument:text pattern:patternText forInvocation:invocation]) {
				--remainingArgs;
			}
		}
		
		NSDictionary *URLQuery = [URL.query queryDictionaryUsingEncoding:NSUTF8StringEncoding];
		if (URLQuery.count) {
			for (NSString *name in [URLQuery keyEnumerator]) {
				id <UXURLPatternText> patternText	= [_query objectForKey:name];
				NSString *text						= [URLQuery objectForKey:name];
				if (patternText) {
					if ([self setArgument:text pattern:patternText forInvocation:invocation]) {
						--remainingArgs;
					}
				}
				else {
					if (!unmatchedArgs) {
						unmatchedArgs = [NSMutableDictionary dictionary];
					}
					[unmatchedArgs setObject:text forKey:name];
				}
			}
		}
		
		if (remainingArgs && unmatchedArgs.count) {
			// If there are unmatched arguments, and the method signature has extra arguments,
			// then pass the dictionary of unmatched arguments as the last argument
			[invocation setArgument:&unmatchedArgs atIndex:_argumentCount + 1];
		}
		
		if (URL.fragment && _fragment) {
			[self setArgument:URL.fragment pattern:_fragment forInvocation:invocation];
		}
	}


	#pragma mark Initializer

	-(id) initWithTarget:(id)target {
		return [self initWithTarget:target mode:UXNavigationModeNone];
	}

	-(id) initWithTarget:(id)target mode:(UXNavigationMode)navigationMode {
		if (self = [super init]) {
			_targetClass	= nil;
			_targetObject	= nil;
			_navigationMode = navigationMode;
			_parentURL		= nil;
			_transition		= 0;
			_argumentCount	= 0;
			
			if (([target class] == target) && navigationMode) {
				_targetClass = target;
			}
			else {
				_targetObject = target;
			}
		}
		return self;
	}

	-(id) init {
		return [self initWithTarget:nil];
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_parentURL);
		[super dealloc];
	}


	#pragma mark UXURLPattern

	-(Class) classForInvocation {
		return _targetClass ? _targetClass : [_targetObject class ];
	}

	
	#pragma mark API

	-(BOOL) isUniversal {
		return [_URL isEqualToString:kUniversalURLPattern];
	}

	-(BOOL) isFragment {
		return [_URL rangeOfString:@"#" options:NSBackwardsSearch].location != NSNotFound;
	}

	-(void) compile {
		if ([_URL isEqualToString:kUniversalURLPattern]) {
			if (!_selector) {
				[self deduceSelector];
			}
		}
		else {
			[self compileURL];
			
			// Don't do this if the pattern is a URL generator
			if (!_selector) {
				[self deduceSelector];
			}
			if (_selector) {
				[self analyzeMethod];
			}
		}
	}

	-(BOOL) matchURL:(NSURL *)URL {
		if (!URL.scheme || !URL.host || ![_scheme isEqualToString:URL.scheme]) {
			return NO;
		}
	
		NSArray *pathComponents		= URL.path.pathComponents;
		NSInteger componentCount	= URL.path.length ? pathComponents.count : (URL.host ? 1 : 0);
		if (componentCount != _path.count) {
			return NO;
		}
		
		if (_path.count && URL.host) {
			id <UXURLPatternText>hostPattern = [_path objectAtIndex:0];
			if (![hostPattern match:URL.host]) {
				return NO;
			}
		}
		
		for (NSInteger i = 1; i < _path.count; ++i) {
			id <UXURLPatternText> pathPattern	= [_path objectAtIndex:i];
			NSString *pathText					= [pathComponents objectAtIndex:i];
			if (![pathPattern match:pathText]) {
				return NO;
			}
		}
		
		if ((URL.fragment && !_fragment) || (_fragment && !URL.fragment)) {
			return NO;
		}
		else if (URL.fragment && _fragment && ![_fragment match:URL.fragment]) {
			return NO;
		}
		
		return YES;
	}

	-(id) invoke:(id)target withURL:(NSURL *)URL query:(NSDictionary *)query {
		id returnValue			= nil;
		NSMethodSignature *sig	= [target methodSignatureForSelector:self.selector];
		if (sig) {
			NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
			[invocation setTarget:target];
			[invocation setSelector:self.selector];
			if (self.isUniversal) {
				[invocation setArgument:&URL atIndex:2];
				if (query) {
					[invocation setArgument:&query atIndex:3];
				}
			}
			else {
				[self setArgumentsFromURL:URL forInvocation:invocation query:query];
			}
			[invocation invoke];
			
			if (sig.methodReturnLength) {
				[invocation getReturnValue:&returnValue];
			}
		}
		return returnValue;
	}

	-(id) createObjectFromURL:(NSURL *)URL query:(NSDictionary *)query {
		id target = nil;
		if (self.instantiatesClass) {
			target = [_targetClass alloc];
		}
		else {
			target = [_targetObject retain];
		}
		
		id returnValue = nil;
		if (_selector) {
			returnValue = [self invoke:target withURL:URL query:query];
		}
		else if (self.instantiatesClass) {
			returnValue = [target init];
		}
		
		[target autorelease];
		return returnValue;
	}

@end

#pragma mark -

@implementation UXURLGeneratorPattern

	@synthesize targetClass = _targetClass;


	#pragma mark Initializer

	-(id) initWithTargetClass:(id)targetClass {
		if (self = [super init]) {
			_targetClass = targetClass;
		}
		return self;
	}

	-(id) init {
		return [self initWithTargetClass:nil];
	}

	-(void) dealloc {
		[super dealloc];
	}


	#pragma mark UXURLPattern

	-(Class) classForInvocation {
		return _targetClass;
	}


	#pragma mark API

	-(void) compile {
		[self compileURL];
		
		for (id <UXURLPatternText> pattern in _path) {
			if ([pattern isKindOfClass:[UXURLWildcard class ]]) {
				UXURLWildcard *wildcard = (UXURLWildcard *)pattern;
				[wildcard deduceSelectorForClass:_targetClass];
			}
		}
		
		for (id <UXURLPatternText> pattern in [_query objectEnumerator]) {
			if ([pattern isKindOfClass:[UXURLWildcard class ]]) {
				UXURLWildcard *wildcard = (UXURLWildcard *)pattern;
				[wildcard deduceSelectorForClass:_targetClass];
			}
		}
	}

	-(NSString *) generateURLFromObject:(id)object {
		NSMutableArray *paths	= [NSMutableArray array];
		NSMutableArray *queries = nil;
		[paths addObject:[NSString stringWithFormat:@"%@:/", _scheme]];
		
		for (id <UXURLPatternText> patternText in _path) {
			NSString *value = [patternText convertPropertyOfObject:object];
			[paths addObject:value];
		}
		
		for (NSString *name in [_query keyEnumerator]) {
			id <UXURLPatternText> patternText	= [_query objectForKey:name];
			NSString *value						= [patternText convertPropertyOfObject:object];
			NSString *pair						= [NSString stringWithFormat:@"%@=%@", name, value];
			if (!queries) {
				queries = [NSMutableArray array];
			}
			[queries addObject:pair];
		}
		
		NSString *path = [paths componentsJoinedByString:@"/"];
		if (queries) {
			NSString *query = [queries componentsJoinedByString:@"&"];
			return [path stringByAppendingFormat:@"?%@", query];
		}
		else {
			return path;
		}
	}

@end
