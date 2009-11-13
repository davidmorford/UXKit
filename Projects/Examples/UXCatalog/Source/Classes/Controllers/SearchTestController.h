
/*!
@project	UXCatalog
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap

*/

#import <UXKit/UXKit.h>

@protocol SearchTestControllerDelegate;
@class MockDataSource;

/*!
@class SearchTestController
@superclass UXTableViewController <UXSearchTextFieldDelegate>
@abstract
@discussion
*/
@interface SearchTestController : UXTableViewController <UXSearchTextFieldDelegate> {
	id <SearchTestControllerDelegate> _delegate;
}

	@property (nonatomic, assign) id <SearchTestControllerDelegate> delegate;

@end

#pragma mark -

/*!
@protocol SearchTestControllerDelegate <NSObject>
@abstract
*/
@protocol SearchTestControllerDelegate <NSObject>

	-(void) searchTestController:(SearchTestController *)controller didSelectObject:(id)object;

@end
