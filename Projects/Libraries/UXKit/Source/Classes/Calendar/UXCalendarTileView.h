
/*!
@project	UXKit
@header		UXCalendarTileView.h
@copyright  (c) 2009 Keith Lazuka
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXStyle.h>

/*!
@abstract used with the UXCalendarTileStateMode mask
*/
#define kUXCalendarTileTypeRegular  (0 << 16)
#define kUXCalendarTileTypeAdjacent (1 << 16)
#define kUXCalendarTileTypeToday    (2 << 16)

/*!
@abstract UXCalendarTileViewState as UIControlState is that it makes it 
much easier to integrate with the existing UXStyleSheet interface.
UXCalendarTileStateMode		Bits 0 and 1 encode the tile mode (regular, adjacent, today)
UXCalendarTileStateMarked	Bit 2 is true when there is data attached to this tile's date.
*/
typedef UIControlState UXCalendarTileState;
enum {
	UXCalendarTileStateMode       = 0x03 << 16, 
	UXCalendarTileStateMarked     = 0x04 << 16
};


/*!
@class UXCalendarTileView
@superclass UIControl <UXStyleDelegate>
@abstract A UXCalendarTileView represents a single square tile for 
an individual date on the calendar.
@discussion should not need to use this class directly it is managed 
by UXCalendarGridView
*/
@interface UXCalendarTileView : UIControl <UXStyleDelegate> {
	NSDate *date;
	UXCalendarTileState state;
	UXStyle *style;
}

	/*!
	@abstract The date that this tile represents.
	*/
	@property (nonatomic, retain) NSDate *date;

	/*!
	@abstract YES if the tile is part of a partial week from an adjacent 
	month (such tiles are grayed out, just like in Apple's mobile calendar app)
	*/
	@property (nonatomic) BOOL belongsToAdjacentMonth;

	/*!
	@abstract YES if the tile should draw a marker underneath the day number. 
	The mark indicates to the user that the tile's date has one or more 
	associated events.
	*/
	@property (nonatomic) BOOL marked;
	
	/*!
	@abstract The head of the UXStyle rendering pipeline that will draw this tile.
	*/
	@property (nonatomic, retain) UXStyle *style;

	/*!
	@abstract UXCalendarGridView manages a pool of reusable UXCalendarTileViews. 
	This method behaves like the prepareForReuse method on the UITableViewCell class.
	*/
	-(void) prepareForReuse;

@end
