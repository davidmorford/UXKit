
/*!
@project    XMLKit
@header     XMLKit.h
@copyright  (c) 2008 Robbie Hanson / Deusty Designs LLC. All rights reserved.
@changes    (c) 2009 Semantap
*/

#define KTCheck(condition, desc, ...)	{ if (!(condition)) { [[NSAssertionHandler currentHandler] handleFailureInMethod:_cmd object:self file:[NSString stringWithUTF8String:__FILE__] lineNumber:__LINE__ description:(desc), ## __VA_ARGS__]; } }
#define KTLastErrorKey					@"KTXML:LastError"

#import <XMLKit/KTXMLNode.h>
#import <XMLKit/KTXMLDocument.h>
#import <XMLKit/KTXMLElement.h>
#import <XMLKit/KTNSString+XML.h>
