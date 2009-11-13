
/*!
@project	UXKit
@header     UXTableItemCell.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXTableViewCell.h>

@class UXTableLinkedItem, UXTableActivityItem, UXTableControlItem, UXTableViewItem;
@class UXImageView, UXErrorView, UXActivityLabel, UXStyledTextLabel, UXStyledText;

/*!
@class UXTableLinkedItemCell
@superclass  UXTableViewCell
@abstract
@discussion
*/
@interface UXTableLinkedItemCell : UXTableViewCell {
	UXTableLinkedItem *_item;
}
@end

#pragma mark -

@interface UXTableTextItemCell : UXTableLinkedItemCell
@end

#pragma mark -

@interface UXTableCaptionItemCell : UXTableLinkedItemCell

	@property (nonatomic, readonly) UILabel *captionLabel;

@end

#pragma mark -

@interface UXTableSubtextItemCell : UXTableLinkedItemCell

	@property (nonatomic, readonly) UILabel *captionLabel;

@end

#pragma mark -

@interface UXTableRightCaptionItemCell : UXTableLinkedItemCell

	@property (nonatomic, readonly) UILabel *captionLabel;

@end

#pragma mark -

@interface UXTableSubtitleItemCell : UXTableLinkedItemCell {
	UXImageView *_imageView2;
}

	@property (nonatomic, readonly, retain) UILabel *subtitleLabel;
	@property (nonatomic, readonly, retain) UXImageView *imageView2;

@end

#pragma mark -

@interface UXTableMessageItemCell : UXTableLinkedItemCell {
	UILabel *_titleLabel;
	UILabel *_timestampLabel;
	UXImageView *_imageView2;
}

	@property (nonatomic, readonly, retain) UILabel *titleLabel;
	@property (nonatomic, readonly) UILabel *captionLabel;
	@property (nonatomic, readonly, retain) UILabel *timestampLabel;
	@property (nonatomic, readonly, retain) UXImageView *imageView2;

@end

#pragma mark -

@interface UXTableMoreButtonCell : UXTableSubtitleItemCell {
	UIActivityIndicatorView *_activityIndicatorView;
	BOOL _animating;
}

	@property (nonatomic, readonly, retain) UIActivityIndicatorView *activityIndicatorView;
	@property (nonatomic) BOOL animating;

@end

#pragma mark -

@interface UXTableImageItemCell : UXTableTextItemCell {
	UXImageView *_imageView2;
}

	@property (nonatomic, readonly, retain) UXImageView *imageView2;

@end

#pragma mark -

@interface UXStyledTextTableItemCell : UXTableLinkedItemCell {
	UXStyledTextLabel *_label;
}

	@property (nonatomic, readonly) UXStyledTextLabel *label;

@end

#pragma mark -

@interface UXStyledTextTableCell : UXTableViewCell {
	UXStyledTextLabel *_label;
}

	@property (nonatomic, readonly) UXStyledTextLabel *label;

@end

#pragma mark -

@interface UXTableActivityItemCell : UXTableViewCell {
	UXTableActivityItem *_item;
	UXActivityLabel *_activityLabel;
}

	@property (nonatomic, readonly, retain) UXActivityLabel *activityLabel;

@end

#pragma mark -

@interface UXTableControlCell : UXTableViewCell {
	UXTableControlItem *_item;
	UIControl *_control;
}

	@property (nonatomic, readonly, retain) UXTableControlItem *item;
	@property (nonatomic, readonly, retain) UIControl *control;

@end

#pragma mark -

@interface UXTableFlushViewCell : UXTableViewCell {
	UXTableViewItem *_item;
	UIView *_view;
}

	@property (nonatomic, readonly, retain) UXTableViewItem *item;
	@property (nonatomic, readonly, retain) UIView *view;

@end
