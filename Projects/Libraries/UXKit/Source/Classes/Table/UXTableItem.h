
/*!
@project	UXKit
@header     UXTableItem.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

@class UXStyledText, UXStyle;

/*!
@class UXTableItem
@superclass NSObject <NSCoding>
@abstract
@discussion
*/
@interface UXTableItem : NSObject <NSCoding> {
	id _userInfo;
}

	@property (nonatomic, retain) id userInfo;

@end

#pragma mark -

@interface UXTableLinkedItem : UXTableItem {
	NSString *_URL;
	NSString *_accessoryURL;
	NSDictionary *_query;
}

	@property (nonatomic, copy) NSString *URL;
	@property (nonatomic, copy) NSString *accessoryURL;
	@property (nonatomic, copy) NSDictionary *query;

@end

#pragma mark -

@interface UXTableTextItem : UXTableLinkedItem {
	NSString *_text;
}

	@property (nonatomic, copy) NSString *text;

	+(id) itemWithText:(NSString *)aTextString;
	+(id) itemWithText:(NSString *)aTextString URL:(NSString *)aURL;
	+(id) itemWithText:(NSString *)aTextString URL:(NSString *)aURL query:(NSDictionary *)aQuery;
	+(id) itemWithText:(NSString *)aTextString URL:(NSString *)aURL accessoryURL:(NSString *)anAccessoryURL;

@end

#pragma mark -

@interface UXTableCaptionItem : UXTableTextItem {
	NSString *_caption;
}

	@property (nonatomic, copy) NSString *caption;

	+(id) itemWithText:(NSString *)aTextString caption:(NSString *)aCaption;
	+(id) itemWithText:(NSString *)aTextString caption:(NSString *)aCaption URL:(NSString *)aURL;
	+(id) itemWithText:(NSString *)aTextString caption:(NSString *)aCaption URL:(NSString *)aURL accessoryURL:(NSString *)anAccessoryURL;

@end

@interface UXTableRightCaptionItem : UXTableCaptionItem
@end

@interface UXTableSubtextItem : UXTableCaptionItem
@end

@interface UXTableSubtitleItem : UXTableTextItem {
	NSString *_subtitle;
	NSString *_imageURL;
	UIImage *_defaultImage;
}

	@property (nonatomic, copy) NSString *subtitle;
	@property (nonatomic, copy) NSString *imageURL;
	@property (nonatomic, retain) UIImage *defaultImage;

	+(id) itemWithText:(NSString *)aTextString subtitle:(NSString *)aSubtitle;
	+(id) itemWithText:(NSString *)aTextString subtitle:(NSString *)aSubtitle URL:(NSString *)aURL;
	+(id) itemWithText:(NSString *)aTextString subtitle:(NSString *)aSubtitle URL:(NSString *)aURL accessoryURL:(NSString *)accessoryURL;
	+(id) itemWithText:(NSString *)aTextString subtitle:(NSString *)aSubtitle imageURL:(NSString *)anImageURL URL:(NSString *)aURL;
	+(id) itemWithText:(NSString *)aTextString subtitle:(NSString *)aSubtitle imageURL:(NSString *)anImageURL defaultImage:(UIImage *)aDefaultImage URL:(NSString *)aURL accessoryURL:(NSString *)anAccessoryURL;

@end

@interface UXTableMessageItem : UXTableTextItem {
	NSString *_title;
	NSString *_caption;
	NSDate *_timestamp;
	NSString *_imageURL;
}

	@property (nonatomic, copy) NSString *title;
	@property (nonatomic, copy) NSString *caption;
	@property (nonatomic, retain) NSDate *timestamp;
	@property (nonatomic, copy) NSString *imageURL;

	+(id) itemWithTitle:(NSString *)aTitle caption:(NSString *)aCaption text:(NSString *)aTextString timestamp:(NSDate *)aTimestamp URL:(NSString *)aURL;
	+(id) itemWithTitle:(NSString *)aTitle caption:(NSString *)aCaption text:(NSString *)aTextString timestamp:(NSDate *)aTimestamp imageURL:(NSString *)anImageURL URL:(NSString *)aURL;

@end

@interface UXTableLongTextItem : UXTableTextItem
@end

@interface UXTableGrayTextItem : UXTableTextItem
@end

@interface UXTableSummaryItem : UXTableTextItem
@end

@interface UXTableLink : UXTableTextItem
@end

@interface UXTableButton : UXTableTextItem
@end

#pragma mark -

@interface UXTableMoreButton : UXTableSubtitleItem {
	BOOL _isLoading;
}

	@property (nonatomic) BOOL isLoading;

@end

#pragma mark -

@interface UXTableImageItem : UXTableTextItem {
	NSString *_imageURL;
	UIImage *_defaultImage;
	UXStyle *_imageStyle;
}

	@property (nonatomic, copy) NSString *imageURL;
	@property (nonatomic, retain) UIImage *defaultImage;
	@property (nonatomic, retain) UXStyle *imageStyle;

	+(id) itemWithText:(NSString *)aTextString imageURL:(NSString *)anImageURL;
	+(id) itemWithText:(NSString *)aTextString imageURL:(NSString *)anImageURL URL:(NSString *)aURL;
	+(id) itemWithText:(NSString *)aTextString imageURL:(NSString *)anImageURL defaultImage:(UIImage *)aDefaultImage URL:(NSString *)aURL;
	+(id) itemWithText:(NSString *)aTextString imageURL:(NSString *)anImageURL defaultImage:(UIImage *)aDefaultImage imageStyle:(UXStyle *)anImageStyle URL:(NSString *)aURL;

@end

#pragma mark -

@interface UXTableRightImageItem : UXTableImageItem
@end

#pragma mark -

@interface UXTableActivityItem : UXTableItem {
	NSString *_text;
}

	@property (nonatomic, copy) NSString *text;

	+(id) itemWithText:(NSString *)aTextString;

@end

#pragma mark -

@interface UXTableStyledTextItem : UXTableLinkedItem {
	UXStyledText *_text;
	UIEdgeInsets _margin;
	UIEdgeInsets _padding;
}

	@property (nonatomic, retain) UXStyledText *text;
	@property (nonatomic) UIEdgeInsets margin;
	@property (nonatomic) UIEdgeInsets padding;

	+(id) itemWithText:(UXStyledText *)aTextString;
	+(id) itemWithText:(UXStyledText *)aTextString URL:(NSString *)aURLString;
	+(id) itemWithText:(UXStyledText *)aTextString URL:(NSString *)aURLString accessoryURL:(NSString *)anAccessoryURL;

@end

@interface UXTableControlItem : UXTableItem {
	NSString *_caption;
	UIControl *_control;
}

	@property (nonatomic, copy) NSString *caption;
	@property (nonatomic, retain) UIControl *control;

	+(id) itemWithCaption:(NSString *)aCaption control:(UIControl *)aControl;

@end

@interface UXTableViewItem : UXTableItem {
	NSString *_caption;
	UIView *_view;
}

	@property (nonatomic, copy) NSString *caption;
	@property (nonatomic, retain) UIView *view;

	+(id) itemWithCaption:(NSString *)aCaption view:(UIView *)aView;

@end
