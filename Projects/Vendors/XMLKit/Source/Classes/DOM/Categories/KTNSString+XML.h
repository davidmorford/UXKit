
/*!
@project    XMLKit
@header     KTNSString+XML.h
@copyright  (c) 2009 - Robbie Hanson
@changes	(c) 2009 - Semantap
*/

#import <Foundation/Foundation.h>
#import <libxml/tree.h>

/*!
@category NSString (KTXMLString)
@abstract
@discussion
*/
@interface NSString (KTXMLString)

	/*!
	@abstract A basic replacement for char, a byte in a UTF-8 encoded string.
	*/
	-(const xmlChar *) xmlChar;

	-(NSString *) trimWhitespace;

@end
