
/*!
@project	UXKit
@header		UXLink.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

@class UXView;

/*!
@class UXLink
@superclass UIControl
@abstract
@discussion
*/
@interface UXLink : UIControl {
	id _URL;
	UXView *_screenView;
}

	/*!
	@abstract The URL that will be loaded when the control is touched.
	*/
	@property (nonatomic, retain) id URL;

@end
