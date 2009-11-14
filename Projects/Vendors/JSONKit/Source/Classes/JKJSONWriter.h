
/*!
@project    JSONKit
@header     JKJSONWriter.h
@copyright  (c) 2007 - 2009, Stig Brautaset
@changes    (c) 2009, Semantap
*/

#import <Foundation/Foundation.h>
#import <JSONKit/JKJSONBase.h>

/*!
@protocol JKJSONWriter
@abstract Options for the writer class.
@discussion ￼ This exists so the JKJSON facade can implement the options in the writer without having to re-declare them.
*/
@protocol JKJSONWriter <NSObject>

	/*!
	@abstract Whether we are generating human-readable (multiline) JSON.
	Set whether or not to generate human-readable JSON. The default is NO, which produces
	JSON without any whitespace. (Except inside strings.) If set to YES, generates human-readable
	JSON with linebreaks after each array value and dictionary key/value pair, indented two
	spaces per nesting level.
	*/
	@property BOOL humanReadable;

	/*!
	@abstract Whether or not to sort the dictionary keys in the output.
	If this is set to YES, the dictionary keys in the JSON output will be in sorted order.
	(This is useful if you need to compare two structures, for example.) The default is NO.
	*/
	@property BOOL sortKeys;

	/*!
	@abstract Return JSON representation (or fragment) for the given object.
	Returns a string containing JSON representation of the passed in value, or nil on error.
	If nil is returned and @p error is not NULL, @p *error can be interrogated to find the cause of the error.
	@param value any instance that can be represented as a JSON fragment
	*/
	-(NSString *) stringWithObject:(id)value;

@end

#pragma mark -

/*!
@class JKJSONWriter 
@superclass  JKJSONBase <JKJSONWriter>
@abstract The JSON writer class. Objective-C types are mapped to JSON types in the following way:
	@li NSNull -> Null
	@li NSString -> String
	@li NSArray -> Array
	@li NSDictionary -> Object
	@li NSNumber (-initWithBool:) -> Boolean
	@li NSNumber -> Number
 
@discussion In JSON the keys of an object must be strings. NSDictionary keys need
not be, but attempting to convert an NSDictionary with non-string keys
into JSON will throw an exception. NSNumber instances created with the +initWithBool: 
method are converted into the JSON boolean "true" and "false" values, and vice
versa. Any other NSNumber instances are converted to a JSON number the way you 
would expect. 
*/
@interface JKJSONWriter : JKJSONBase <JKJSONWriter> {
@private
	BOOL sortKeys;
	BOOL humanReadable;
}
	
	-(NSString *) stringWithFragment:(id)value;
	
@end

#pragma mark -

/*!
@category NSObject (JKJSONProxy)
@abstract Allows generation of JSON for otherwise unsupported classes.
@discussion If you have a custom class that you want to create a JSON representation for you can implement
this method in your class. It should return a representation of your object defined
in terms of objects that can be translated into JSON. For example, a Person
object might implement it like this:

@code
-(id)jsonProxyObject {
	return [NSDictionary dictionaryWithObjectsAndKeys:
	        name, @"name",
	        phone, @"phone",
	        email, @"email",
	        nil];
}
@endcode
*/
@interface NSObject (JKJSONProxy)

	-(id) proxyForJson;

@end

