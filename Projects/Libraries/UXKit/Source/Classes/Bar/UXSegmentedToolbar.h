
/*!
@project    UXKit
@header     UXSegmentedToolbar.h
@copyright  (c) 2009 Rodrigo Mazzilli
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXView.h>

/*!
@class UXSegmentedToolbar
@superclass UIToolbar
@abstract A segmented toolbar has a UISegmentedControl inside and 
manages its width accordingly.
@discussion 
*/
@interface UXSegmentedToolbar : UIToolbar {
	UISegmentedControl *segmentedControl;
	CGFloat margin;
}

	@property (nonatomic, retain) UISegmentedControl *segmentedControl;;

	-(void) setSegmentedItems:(NSArray *)itemNames;

@end
