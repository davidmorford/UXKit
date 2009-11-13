
/*!
@project	UXKit
@header     UXErrorView.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

/*!
@class UXErrorView
@superclass UIView
@abstract
@discussion
*/
@interface UXErrorView : UIView {
	UIImageView *_imageView;
	UILabel *_titleView;
	UILabel *_subtitleView;
}

	@property (nonatomic, retain) UIImage *image;
	@property (nonatomic, copy) NSString *title;
	@property (nonatomic, copy) NSString *subtitle;

	-(id) initWithTitle:(NSString *)aTitle subtitle:(NSString *)aSubtitle image:(UIImage *)anImage;

@end
