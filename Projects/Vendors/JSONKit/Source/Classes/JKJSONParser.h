
/*!
@project    JSONKit
@header     JKJSONParser.h
@copyright  (c) 2007 - 2009, Stig Brautaset
@changes    (c) 2009, Semantap
*/

#import <Foundation/Foundation.h>
#import <JSONKit/JKJSONBase.h>

/*!
@protocol JKJSONParser
@abstract Options for the parser class.
@discussion Exists so the JKJSON facade can implement the options 
in the parser without having to re-declare them.
*/
@protocol JKJSONParser <NSObject>

	/*!
	@abstract Return the object represented by the given string.
	@discussion Returns the object represented by the passed-in string or nil on error. 
	The returned object can be a string, number, boolean, null, array or dictionary.
	@param repr the json string to parse
	*/
	-(id) objectWithString:(NSString *)repr;

@end

#pragma mark -

/*!
@class JKJSONParser 
@superclass  JKJSONBase <JKJSONParser>
@abstract The JSON parser class. JSON is mapped to Objective-C types in the following way:
@li Null -> NSNull
@li String -> NSMutableString
@li Array -> NSMutableArray
@li Object -> NSMutableDictionary
@li Boolean -> NSNumber (initialised with -initWithBool:)
@li Number -> NSDecimalNumber
@discussion  Since Objective-C doesn't have a dedicated class for boolean values, these 
turns into NSNumber instances. These are initialised with the -initWithBool: method, and
round-trip back to JSON properly. (They won't silently suddenly become 0 or 1; they'll be
represented as 'true' and 'false' again.) JSON numbers turn into NSDecimalNumber instances,
as we can thus avoid any loss of precision. (JSON allows ridiculously large numbers.)
*/
@interface JKJSONParser : JKJSONBase <JKJSONParser> {
@private
	const char *c;
}

	-(id) fragmentWithString:(id)repr;

@end
