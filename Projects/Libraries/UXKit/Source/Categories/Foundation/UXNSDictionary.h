
/*!
@project    UXKit
@header     UXNSDictionary.h
@copyright  (c) 2009, Facebook
@changes	(c) 2009, Semantap
@created    11/29/09
*/

#import <Foundation/Foundation.h>

/*!
@category NSMutableDictionary (UXNSMutableDictionary)
@abstract
*/
@interface NSMutableDictionary (UXNSMutableDictionary)

	/*!
	@abstract Adds a string on the condition that it's non-nil and non-empty.
	*/
	-(void) setNonEmptyString:(NSString *)string forKey:(id)key;

@end
