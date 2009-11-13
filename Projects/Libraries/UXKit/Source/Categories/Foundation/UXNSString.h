
/*!
@project	UXKit
@header     UXNSString.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UXKit/UXGlobal.h>
#import <UXKit/UXURLMap.h>
#import <UXKit/UXNavigator.h>

/*!
@class NSString (UXNSString)
@abstract
@discussion
*/
@interface NSString (UXNSString)

	/*!
	@abstract Determines if the string contains only whitespace.
	*/
	-(BOOL) isWhitespace;

	/*!
	@abstract Determines if the string is empty or contains only whitespace.
	*/
	-(BOOL) isEmptyOrWhitespace;

	/*!
	@abstract Parses a URL query string into a dictionary.
	*/
	-(NSDictionary *) queryDictionaryUsingEncoding:(NSStringEncoding)encoding;

	/*!
	@abstractParses a URL, adds query parameters to its query, and re-encodes it as a new URL.
	*/
	-(NSString * ) stringByAddingQueryDictionary:(NSDictionary *)query;

	/*!
	@abstract Returns a string with all HTML tags removed.
	*/
	-(NSString *) stringByRemovingHTMLTags;

	/*!
	@abstract Converts the string to an object using UXURLMap.
	*/
	-(id) objectValue;

	/*!
	@abstract Opens a URL with the string using UXURLMap.
	*/
	-(void) openURL;
	
	-(void) openURLFromButton:(UIView *)aButtonView;

@end

#pragma mark -

NSString *
UXHexStringFromBytes(void *bytes, NSUInteger len);