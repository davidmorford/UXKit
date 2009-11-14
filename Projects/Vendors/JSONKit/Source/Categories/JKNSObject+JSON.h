
/*!
@project    JSONKit
@header     JKNSObject+JSON.h
@copyright  (c) 2007 - 2009, Stig Brautaset
@changes    (c) 2009, Semantap
*/

#import <Foundation/Foundation.h>

/*!
@category NSObject (JKJSON)
@abstract Adds JSON generation to Foundation classes
@discussion This is a category on NSObject that adds methods for returning JSON representations
of standard objects to the objects themselves. This means you can call the
-JSONRepresentation method on an NSArray object and it'll do what you want.
*/
@interface NSObject (JKJSON)

	/*!
	@abstract Returns a string containing the receiver encoded as a JSON fragment.
	@discussion  This method is added as a category on NSObject but is only actually
	supported for the following objects:
	@li NSDictionary
	@li NSArray
	@li NSString
	@li NSNumber (also used for booleans)
	@li NSNull
	@deprecated Given we bill ourselves as a "strict" JSON library, this method should be removed.
	*/
	-(NSString *) JSONFragment;

	/*!
	@abstract Returns a string containing the receiver encoded in JSON.
	@discussion This method is added as a category on NSObject but is only actually
	supported for the following objects:
	@li NSDictionary
	@li NSArray
	*/
	-(NSString *) JSONRepresentation;

@end

