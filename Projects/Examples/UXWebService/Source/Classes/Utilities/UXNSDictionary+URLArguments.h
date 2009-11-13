
#import <Foundation/Foundation.h>

/*!
@category NSDictionary (UXNSDictionaryURLArguments)
@abstract￼ Utility for building a URL or POST argument string.
@discussion
*/
@interface NSDictionary (UXNSDictionaryURLArguments)

	/*!
	Gets a string representation of the dictionary in the form
	key1=value1&key2&value2&...&keyN=valueN, suitable for use as either
	URL arguments (after a '?') or POST body. Keys and values will be escaped
	automatically, so should be unescaped in the dictionary.
	*/
	-(NSString *) httpArgumentsString;

@end
