
/*!
@project    UXKit
@header     UXLauncherItem.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

@class UXLauncherView;

/*!
@class UXLauncherItem
@superclass NSObject <NSCoding>
@abstract
@discussion
*/
@interface UXLauncherItem : NSObject <NSCoding> {
	UXLauncherView *_launcher;
	NSString *_title;
	NSString *_image;
	NSString *_URL;
	NSString *_style;
	NSInteger _badgeNumber;
	BOOL _canDelete;
}

	@property (nonatomic, assign) UXLauncherView *launcher;
	
	@property (nonatomic, copy) NSString *title;
	@property (nonatomic, copy) NSString *image;
	@property (nonatomic, copy) NSString *URL;
	@property (nonatomic, copy) NSString *style;
	
	@property (nonatomic) NSInteger badgeNumber;
	@property (nonatomic) BOOL canDelete;

	-(id) initWithTitle:(NSString *)aTitle image:(NSString *)anImage URL:(NSString *)aURL;
	-(id) initWithTitle:(NSString *)aTitle image:(NSString *)anImage URL:(NSString *)aURL canDelete:(BOOL)flag;

@end
