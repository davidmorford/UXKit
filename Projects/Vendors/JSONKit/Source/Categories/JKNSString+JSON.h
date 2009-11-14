
/*!
@project    JSONKit
@header     JKNSString+JSON.h
@copyright  (c) 2007 - 2009, Stig Brautaset
@changes    (c) 2009, Semantap
*/

#import <Foundation/Foundation.h>

/*!
@category NSString (JKJSON)
@abstract Adds JSON parsing methods to NSString
@discussion adds methods for parsing the target string.
*/
@interface NSString (JKJSON)

	/*!
	@abstract Returns the object represented in the receiver, or nil on error. 
	@discussion Returns a a scalar object represented by the string's JSON fragment representation.
	@deprecated Given we bill ourselves as a "strict" JSON library, this method should be removed.
	*/
	-(id) JSONFragmentValue;

	/*!
	@abstract Returns the NSDictionary or NSArray represented by the current string's JSON representation.
	@discussion Returns the dictionary or array represented in the receiver, or nil on error.
	@result Returns the NSDictionary or NSArray represented by the current string's JSON representation.
	*/
	-(id) JSONValue;

@end
