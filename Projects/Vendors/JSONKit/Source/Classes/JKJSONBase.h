
/*!
@project    JSONKit
@header     JKJSONBase.h
@copyright  (c) 2007 - 2009, Stig Brautaset
@changes    (c) 2009, Semantap
*/

#import <Foundation/Foundation.h>

extern NSString * JKJSONErrorDomain;
enum {
    EUNSUPPORTED = 1,
    EPARSENUM,
    EPARSE,
    EFRAGMENT,
    ECTRL,
    EUNICODE,
    EDEPTH,
    EESCAPE,
    ETRAILCOMMA,
    ETRAILGARBAGE,
    EEOF,
    EINPUT
};

/*!
@class JKJSONBase 
@superclass  NSObject
@abstract ￼Common base class for parsing & writing.
@discussion ￼ This class contains the common error-handling code and option between the parser/writer.
*/
@interface JKJSONBase : NSObject {
	NSMutableArray *errorTrace;
@protected
	NSUInteger depth;
	NSUInteger maxDepth;
}

	/*!
	@abstract The maximum recursing depth.
	Defaults to 512. If the input is nested deeper than this the input will be deemed to be
	malicious and the parser returns nil, signalling an error. ("Nested too deep".) You can
	turn off this security feature by setting the maxDepth value to 0.
	*/
	@property NSUInteger maxDepth;

	/*!
	@abstract Return an error trace, or nil if there was no errors.
	Note that this method returns the trace of the last method that failed.
	You need to check the return value of the call you're making to figure out
	if the call actually failed, before you know call this method.
	*/
	@property (copy, readonly) NSArray *errorTrace;

	/*! 
	@internal for use in subclasses to add errors to the stack trace
	*/
	-(void) addErrorWithCode:(NSUInteger)code description:(NSString *)str;

	/*! 
	@internal for use in subclasess to clear the error before a new parsing attempt
	*/
	-(void) clearErrorTrace;

@end
