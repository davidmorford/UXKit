
/*!
@project	UXKit
@header     UXStyleSheet.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

@class UXStyle;

/*!
@class UXStyleSheet
@superclass NSObject
@abstract
@discussion
*/
@interface UXStyleSheet : NSObject {
	NSMutableDictionary *_styles;
}

	+(UXStyleSheet *) globalStyleSheet;
	+(void) setGlobalStyleSheet:(UXStyleSheet *)styleSheet;

	-(UXStyle *) styleWithSelector:(NSString *)selector;
	-(UXStyle *) styleWithSelector:(NSString *)selector forState:(UIControlState)state;
	
	//-(UXStyle *) styleFromResourceBundleForSelector:(NSString *)selector;
	
	-(void) freeMemory;

@end
