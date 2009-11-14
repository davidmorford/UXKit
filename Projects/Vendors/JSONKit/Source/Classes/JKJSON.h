
/*!
@project    JSONKit
@header     JKJSON.h
@copyright  (c) 2007 - 2009, Stig Brautaset
@changes    (c) 2009, Semantap
*/

#import <Foundation/Foundation.h>
#import <JSONKit/JKJSONParser.h>
#import <JSONKit/JKJSONWriter.h>

/*!
@class JKJSON 
@superclass JKJSONBase
@protocols <JKJSONParser, JKJSONWriter>
@abstract Facade for JKJSONWriter/JKJSONParser.
@discussion Requests are forwarded to instances of JKJSONWriter and JKJSONParser.
*/
@interface JKJSON : JKJSONBase <JKJSONParser, JKJSONWriter> {
@private
	JKJSONParser *jsonParser;
	JKJSONWriter *jsonWriter;
}

	/*!
	@abstract Return the fragment represented by the given string
	*/
	-(id) fragmentWithString:(NSString *)jsonrep error:(NSError **)anError;

	/*!
	@abstract Return the object represented by the given string
	*/
	-(id) objectWithString:(NSString *)jsonrep error:(NSError **)anError;

	/*!
	@abstract Parse the string and return the represented object (or scalar)
	*/
	-(id) objectWithString:(id)aValue allowScalar:(BOOL)flag error:(NSError **)anError;

	/*!
	@abstract Return JSON representation of an array  or dictionary
	*/
	-(NSString *) stringWithObject:(id)aValue error:(NSError **)anError;

	/*!
	@abstract Return JSON representation of any legal JSON value
	*/
	-(NSString *) stringWithFragment:(id)aValue error:(NSError **)anError;

	/*!
	@abstract Return JSON representation (or fragment) for the given object
	*/
	-(NSString *) stringWithObject:(id)aValue allowScalar:(BOOL)flag error:(NSError **)anError;

@end
