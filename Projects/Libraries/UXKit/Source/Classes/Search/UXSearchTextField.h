
/*!
@project	UXKit
@header		UXSearchTextField.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXTableViewDataSource.h>

@protocol UXTableViewDataSource;
@class UXSearchTextFieldInternal, UXView;

/*!
@class UXSearchTextField
@superclass UITextField <UITableViewDelegate>
@abstract
@discussion
*/
@interface UXSearchTextField : UITextField <UITableViewDelegate> {
	id <UXTableViewDataSource> _dataSource;
	UXSearchTextFieldInternal *_internal;
	UITableView *_tableView;
	UXView *_shadowView;
	UIButton *_screenView;
	UINavigationItem *_previousNavigationItem;
	UIBarButtonItem *_previousRightBarButtonItem;
	NSTimer *_searchTimer;
	CGFloat _rowHeight;
	BOOL _searchesAutomatically;
	BOOL _showsDoneButton;
	BOOL _showsDarkScreen;
}

	@property (nonatomic, retain) id <UXTableViewDataSource> dataSource;
	@property (nonatomic, readonly) UITableView *tableView;
	@property (nonatomic) CGFloat rowHeight;
	@property (nonatomic, readonly) BOOL hasText;
	@property (nonatomic) BOOL searchesAutomatically;
	@property (nonatomic) BOOL showsDoneButton;
	@property (nonatomic) BOOL showsDarkScreen;

	-(void) search;

	-(void) showSearchResults:(BOOL)show;

	-(UIView *) superviewForSearchResults;

	-(CGRect) rectForSearchResults:(BOOL)withKeyboard;

	-(BOOL) shouldUpdate:(BOOL)emptyText;

@end

#pragma mark -

/*!
@protocol UXSearchTextFieldDelegate <UITextFieldDelegate>
@abstract
*/
@protocol UXSearchTextFieldDelegate <UITextFieldDelegate>

	-(void) textField:(UXSearchTextField *)textField didSelectObject:(id)object;

@end
