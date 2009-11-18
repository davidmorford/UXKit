
/*!
@project    UXKit
@header     UIXApplication.h
@copyright  (c) 2009, Semantap
@created    11/15/2009
*/

#import <UIKit/UIApplication.h>

/*!
@category UIApplication (UIXApplication)
@abstract
@discussion
*/
@interface UIApplication (UIXApplication)

	+(id) sharedApplicationDelegate;

	/*!
	@method  applicationVersion
	@abstract Retrieves the bundle version from the Info.plist with kCFBundleVersionKey.
	@result 
	*/
	+(NSString *) applicationVersion;

	+(NSString *) documentsDirectory;

	+(NSString *) cachesDirectory;

@end
