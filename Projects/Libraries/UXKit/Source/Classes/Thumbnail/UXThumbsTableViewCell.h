
/*!
@project	UXKit
@header     UXThumbsTableViewCell.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXTableViewCell.h>

@protocol UXPhoto, UXThumbsTableViewCellDelegate;
@class UXThumbView;

/*!
@class UXThumbsTableViewCell
@superclass UXTableViewCell
@abstract
@discussion
*/
@interface UXThumbsTableViewCell : UXTableViewCell {
	id <UXThumbsTableViewCellDelegate> _delegate;
	id <UXPhoto> _photo;
	NSMutableArray *_thumbViews;
	CGFloat _thumbSize;
	CGPoint _thumbOrigin;
	NSInteger _columnCount;
}

	@property (nonatomic, retain) id <UXPhoto> photo;
	@property (nonatomic, assign) id <UXThumbsTableViewCellDelegate> delegate;
	@property (nonatomic) CGFloat thumbSize;
	@property (nonatomic) CGPoint thumbOrigin;
	@property (nonatomic) NSInteger columnCount;

	-(void) suspendLoading:(BOOL)suspended;

@end

#pragma mark -

/*!
@protocol UXThumbsTableViewCellDelegate <NSObject>
@abstract
*/
@protocol UXThumbsTableViewCellDelegate <NSObject>

	-(void) thumbsTableViewCell:(UXThumbsTableViewCell *)cell didSelectPhoto:(id <UXPhoto>)photo;

@end
