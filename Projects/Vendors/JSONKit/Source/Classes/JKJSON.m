
#import <JSONKit/JKJSON.h>

@implementation JKJSON
	
	#pragma mark Initializer
	
	-(id) init {
		self = [super init];
		if (self) {
			jsonWriter = [JKJSONWriter new];
			jsonParser = [JKJSONParser new];
			[self setMaxDepth:512];
		}
		return self;
	}

	#pragma mark Writer

	-(NSString *) stringWithObject:(id)obj {
		NSString *repr = [jsonWriter stringWithObject:obj];
		if (repr) {
			return repr;
		}
		
		[errorTrace release];
		errorTrace = [[jsonWriter errorTrace] mutableCopy];
		return nil;
	}

	/*!
	@abstract Returns a string containing JSON representation of the passed in value, or nil on error.
	If nil is returned and @p error is not NULL, @p *error can be interrogated to find the cause of the error.
	@param value any instance that can be represented as a JSON fragment
	@param allowScalar wether to return json fragments for scalar objects
	@param error used to return an error by reference (pass NULL if this is not desired)
	@deprecated Given we bill ourselves as a "strict" JSON library, this method should be removed.
	*/
	-(NSString *) stringWithObject:(id)value allowScalar:(BOOL)allowScalar error:(NSError * *)error {
		NSString *json = allowScalar ? [jsonWriter stringWithFragment:value] : [jsonWriter stringWithObject:value];
		if (json) {
			return json;
		}
		
		[errorTrace release];
		errorTrace = [[jsonWriter errorTrace] mutableCopy];
		
		if (error) {
			*error = [errorTrace lastObject];
		}
		return nil;
	}

	/*!
	@abstract Returns a string containing JSON representation of the passed in value, or nil on error.
	If nil is returned and @p error is not NULL, @p error can be interrogated to find the cause of the error.
	@param value any instance that can be represented as a JSON fragment
	@param error used to return an error by reference (pass NULL if this is not desired)
	@deprecated Given we bill ourselves as a "strict" JSON library, this method should be removed.
	*/
	-(NSString *) stringWithFragment:(id)value error:(NSError **)error {
		return [self stringWithObject:value allowScalar:YES error:error];
	}

	/*!
	@abstract Returns a string containing JSON representation of the passed in value, or nil on error.
	If nil is returned and @p error is not NULL, @p error can be interrogated to find the cause of the error.
	@param value a NSDictionary or NSArray instance
	@param error used to return an error by reference (pass NULL if this is not desired)
	*/
	-(NSString *) stringWithObject:(id)value error:(NSError * *)error {
		return [self stringWithObject:value allowScalar:NO error:error];
	}

	#pragma mark Parsing

	-(id) objectWithString:(NSString *)repr {
		id obj = [jsonParser objectWithString:repr];
		if (obj) {
			return obj;
		}
		
		[errorTrace release];
		errorTrace = [[jsonParser errorTrace] mutableCopy];
		
		return nil;
	}

	/*!
	@abstract Returns the object represented by the passed-in string or nil on error. The returned object can be
	a string, number, boolean, null, array or dictionary.
	@param value the json string to parse
	@param allowScalar whether to return objects for JSON fragments
	@param error used to return an error by reference (pass NULL if this is not desired)
	@deprecated Given we bill ourselves as a "strict" JSON library, this method should be removed.
	*/
	-(id) objectWithString:(id)value allowScalar:(BOOL)allowScalar error:(NSError * *)error {
		id obj = allowScalar ? [jsonParser fragmentWithString:value] : [jsonParser objectWithString:value];
		if (obj) {
			return obj;
		}
		
		[errorTrace release];
		errorTrace = [[jsonParser errorTrace] mutableCopy];
		
		if (error) {
			*error = [errorTrace lastObject];
		}
		return nil;
	}

	/*!
	@abstract Returns the object represented by the passed-in string or nil on error. The returned object can be
	a string, number, boolean, null, array or dictionary.	 
	@param repr the json string to parse
	@param error used to return an error by reference (pass NULL if this is not desired)
	@deprecated Given we bill ourselves as a "strict" JSON library, this method should be removed.
	*/
	-(id) fragmentWithString:(NSString *)repr error:(NSError * *)error {
		return [self objectWithString:repr allowScalar:YES error:error];
	}

	/*!
	@abstract Returns the object represented by the passed-in string or nil on error. The returned object
	will be either a dictionary or an array.
	@param repr the json string to parse
	@param error used to return an error by reference (pass NULL if this is not desired)
	*/
	-(id) objectWithString:(NSString *)repr error:(NSError * *)error {
		return [self objectWithString:repr allowScalar:NO error:error];
	}

	#pragma mark Properties : Parsing

	-(NSUInteger) maxDepth {
		return jsonParser.maxDepth;
	}

	-(void) setMaxDepth:(NSUInteger)d {
		jsonWriter.maxDepth = jsonParser.maxDepth = d;
	}


	#pragma mark Properties : Writing

	-(BOOL) humanReadable {
		return jsonWriter.humanReadable;
	}

	-(void) setHumanReadable:(BOOL)x {
		jsonWriter.humanReadable = x;
	}

	-(BOOL) sortKeys {
		return jsonWriter.sortKeys;
	}

	-(void) setSortKeys:(BOOL)x {
		jsonWriter.sortKeys = x;
	}


	#pragma mark -

	-(void) dealloc {
		[jsonWriter release];
		[jsonParser release];
		[super dealloc];
	}

@end
