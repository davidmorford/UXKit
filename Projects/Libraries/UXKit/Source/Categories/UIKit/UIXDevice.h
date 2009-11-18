
/*!
@project    UXKit
@header     UIXDevice.h
@copyright  (c) 2009, Semantap
@created    11/15/2009
*/

#import <UIKit/UIKit.h>

/*!
@category UIDevice (UIXDevice)
@abstract
@discussion
*/
@interface UIDevice (UIXDevice)

	/*!
	@abstract Available device memory in MB
	*/
	@property (readonly) double availableMemory;

	@property (readonly) NSString *modelVersion;

@end
