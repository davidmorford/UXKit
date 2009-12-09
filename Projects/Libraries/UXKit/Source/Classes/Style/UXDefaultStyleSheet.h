
/*!
@project	UXKit
@header     UXDefaultStyleSheet.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXStyleSheet.h>

@class UXShape;

/*!
@class UXDefaultStyleSheet
@superclass UXStyleSheet
@abstract
@discussiom
*/
@interface UXDefaultStyleSheet : UXStyleSheet

	#pragma mark Text Colors

	@property (nonatomic, readonly) UIColor *textColor;
	@property (nonatomic, readonly) UIColor *highlightedTextColor;
	@property (nonatomic, readonly) UIColor *placeholderTextColor;
	@property (nonatomic, readonly) UIColor *timestampTextColor;
	@property (nonatomic, readonly) UIColor *linkTextColor;
	@property (nonatomic, readonly) UIColor *moreLinkTextColor;
	@property (nonatomic, readonly) UIColor *selectedTextColor;
	@property (nonatomic, readonly) UIColor *photoCaptionTextColor;

	#pragma mark Bar Colors

	@property (nonatomic, readonly) UIColor *navigationBarTintColor;
	@property (nonatomic, readonly) UIColor *toolbarTintColor;
	@property (nonatomic, readonly) UIColor *segmentedControlTintColor;
	@property (nonatomic, readonly) UIColor *searchBarTintColor;
	@property (nonatomic, readonly) UIColor *screenBackgroundColor;
	@property (nonatomic, readonly) UIColor *backgroundColor;
	@property (nonatomic, readonly) UIColor *launcherBackgroundColor;


	#pragma mark Table Colors

	@property (nonatomic, readonly) UIColor *tableActivityTextColor;
	@property (nonatomic, readonly) UIColor *tableErrorTextColor;
	@property (nonatomic, readonly) UIColor *tableSubTextColor;
	@property (nonatomic, readonly) UIColor *tableTitleTextColor;
	@property (nonatomic, readonly) UIColor *tableHeaderTextColor;
	@property (nonatomic, readonly) UIColor *tableHeaderShadowColor;
	@property (nonatomic, readonly) UIColor *tableHeaderTintColor;
	@property (nonatomic, readonly) UIColor *tableSeparatorColor;
	@property (nonatomic, readonly) UIColor *tablePlainBackgroundColor;
	@property (nonatomic, readonly) UIColor *tableGroupedBackgroundColor;
	@property (nonatomic, readonly) UIColor *searchTableBackgroundColor;
	@property (nonatomic, readonly) UIColor *searchTableSeparatorColor;

	#pragma mark Tint Color

	@property (nonatomic, readonly) UIColor *tabTintColor;
	@property (nonatomic, readonly) UIColor *tabBarTintColor;

	@property (nonatomic, readonly) UIColor *messageFieldTextColor;
	@property (nonatomic, readonly) UIColor *messageFieldSeparatorColor;
	
	@property (nonatomic, readonly) UIColor *thumbnailBackgroundColor;

	@property (nonatomic, readonly) UIColor *postButtonColor;

	#pragma mark Fonts

	@property (nonatomic, readonly) UIFont *font;
	@property (nonatomic, readonly) UIFont *buttonFont;
	@property (nonatomic, readonly) UIFont *tableFont;
	@property (nonatomic, readonly) UIFont *tableSmallFont;
	@property (nonatomic, readonly) UIFont *tableTitleFont;
	@property (nonatomic, readonly) UIFont *tableTimestampFont;
	@property (nonatomic, readonly) UIFont *tableButtonFont;
	@property (nonatomic, readonly) UIFont *tableSummaryFont;
	@property (nonatomic, readonly) UIFont *tableHeaderPlainFont;
	@property (nonatomic, readonly) UIFont *tableHeaderGroupedFont;
	@property (nonatomic, readonly) UIFont *photoCaptionFont;
	@property (nonatomic, readonly) UIFont *messageFont;
	@property (nonatomic, readonly) UIFont *errorTitleFont;
	@property (nonatomic, readonly) UIFont *errorSubtitleFont;
	@property (nonatomic, readonly) UIFont *activityLabelFont;
	@property (nonatomic, readonly) UIFont *activityBannerFont;

	#pragma mark -

	@property (nonatomic, readonly) UITableViewCellSelectionStyle tableSelectionStyle;
		
	
	#pragma mark API

	-(UXStyle *) toolbarButtonForState:(UIControlState)state shape:(UXShape *)shape tintColor:(UIColor *)color font:(UIFont *)aFont;
	-(UXStyle *) pageDotWithColor:(UIColor *)color;	@property (nonatomic, readonly) UIColor *calendarHeaderTopColor;

	@property (nonatomic, readonly) UIColor *calendarHeaderBottomColor;
	@property (nonatomic, readonly) UIColor *calendarGridTopColor;
	@property (nonatomic, readonly) UIColor *calendarGridBottomColor;
	@property (nonatomic, readonly) UIColor *calendarTextColor;
	@property (nonatomic, readonly) UIColor *calendarTextLightColor;
	@property (nonatomic, readonly) UIColor *calendarTileDimmedOutColor;
	@property (nonatomic, readonly) UIColor *calendarGridLineHighlightColor;
	@property (nonatomic, readonly) UIColor *calendarGridLineShadowColor;
	@property (nonatomic, readonly) UIColor *calendarContentSeparatorColor;

	-(UXStyle *) selectionFillStyle:(UXStyle *)next;
	-(UXStyle *) calendarTileForState:(UIControlState)state;
	

@end

#pragma mark -

/*!
@category UXDefaultStyleSheet (Styles)
@abstract
@discussion
*/
@interface UXDefaultStyleSheet (Styles)

	-(UXStyle *) linkText:(UIControlState)state;
	-(UXStyle *) linkHighlighted;
	-(UXStyle *) thumbView:(UIControlState)state;

	#pragma mark Toolbar

	-(UXStyle *) toolbarButton:(UIControlState)state;
	-(UXStyle *) toolbarBackButton:(UIControlState)state;
	-(UXStyle *) toolbarForwardButton:(UIControlState)state;
	-(UXStyle *) toolbarRoundButton:(UIControlState)state;
	-(UXStyle *) blackToolbarButton:(UIControlState)state;
	-(UXStyle *) grayToolbarButton:(UIControlState)state;
	-(UXStyle *) blackToolbarForwardButton:(UIControlState)state;
	-(UXStyle *) blackToolbarRoundButton:(UIControlState)state;

	#pragma mark Search

	-(UXStyle *) searchTextField;
	-(UXStyle *) searchBar;
	-(UXStyle *) searchTableShadow;
	-(UXStyle *) blackSearchBar;

	#pragma mark Tables
	
	-(UXStyle *) tableHeader;

	#pragma mark Bezels

	-(UXStyle *) blackBezel;
	-(UXStyle *) whiteBezel;
	-(UXStyle *) blackBanner;

	#pragma mark Badges

	-(UXStyle *) badgeWithFontSize:(CGFloat)fontSize;
	-(UXStyle *) miniBadge;
	-(UXStyle *) badge;
	-(UXStyle *) largeBadge;

	#pragma mark Tabs

	-(UXStyle *) tabBar;
	-(UXStyle *) tabStrip;
	-(UXStyle *) tabGrid;
	-(UXStyle *) tabGridTabImage:(UIControlState)state;
	-(UXStyle *) tabGridTab:(UIControlState)state corner:(short)corner;
	-(UXStyle *) tabGridTabTopLeft:(UIControlState)state;
	-(UXStyle *) tabGridTabTopRight:(UIControlState)state;
	-(UXStyle *) tabGridTabBottomRight:(UIControlState)state;
	-(UXStyle *) tabGridTabBottomLeft:(UIControlState)state;
	-(UXStyle *) tabGridTabLeft:(UIControlState)state;
	-(UXStyle *) tabGridTabRight:(UIControlState)state;
	-(UXStyle *) tabGridTabCenter:(UIControlState)state;
	-(UXStyle *) tab:(UIControlState)state;
	-(UXStyle *) tabRound:(UIControlState)state;
	-(UXStyle *) tabOverflowLeft;
	-(UXStyle *) tabOverflowRight;
	-(UXStyle *) rounded;

	#pragma mark Post Editor

	-(UXStyle *) postTextEditor;

	#pragma mark Photos

	-(UXStyle *) photoCaption;
	-(UXStyle *) photoStatusLabel;
	-(UXStyle *) pageDot:(UIControlState)aState;

	#pragma mark Photos

	-(UXStyle *) launcherButton:(UIControlState)state;
	-(UXStyle *) launcherButtonImage:(UIControlState)state;
	-(UXStyle *) launcherCloseButtonImage:(UIControlState)state;
	-(UXStyle *) launcherCloseButton:(UIControlState)state;
	-(UXStyle *) launcherPageDot:(UIControlState)state;

	#pragma mark Text Bar

	-(UXStyle *) textBar;
	-(UXStyle *) textBarTextField;
	-(UXStyle *) textBarPostButton:(UIControlState)state;

	#pragma mark Input Panel
	
	-(UXStyle *) panelContent;
	-(UXStyle *) panel;

@end

#pragma mark -

/*!
@category UXDefaultStyleSheet (Calendar)
@abstract
@discussion
*/
@interface UXDefaultStyleSheet (Calendar)

@end
