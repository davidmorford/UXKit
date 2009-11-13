
/*!
@project	UXKit
@header		UXActivityLabel.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

typedef NSUInteger UXActivityLabelStyle;
enum {
	UXActivityLabelStyleWhite,
	UXActivityLabelStyleGray,
	UXActivityLabelStyleBlackBox,
	UXActivityLabelStyleBlackBezel,
	UXActivityLabelStyleBlackBanner,
	UXActivityLabelStyleWhiteBezel,
	UXActivityLabelStyleWhiteBox
};

@class UXView, UXButton;

/*!
@class UXActivityLabel
@superclass UIView
@abstract
@discussion
*/
@interface UXActivityLabel : UIView {
	UXActivityLabelStyle _style;
	UXView *_bezelView;
	UIProgressView *_progressView;
	UIActivityIndicatorView *_activityIndicator;
	UILabel *_label;
	float _progress;
	BOOL _smoothesProgress;
	NSTimer *_smoothTimer;
}

	@property (nonatomic, readonly) UXActivityLabelStyle style;
	@property (nonatomic, assign) NSString *text;
	@property (nonatomic, assign) UIFont *font;
	@property (nonatomic) float progress;
	@property (nonatomic) BOOL isAnimating;
	@property (nonatomic) BOOL smoothesProgress;
	
	-(id) initWithFrame:(CGRect)aFrame style:(UXActivityLabelStyle)aStyle;
	-(id) initWithFrame:(CGRect)aFrame style:(UXActivityLabelStyle)aStyle text:(NSString *)aTextString;
	-(id) initWithStyle:(UXActivityLabelStyle)aStyle;

@end
