
/*!
@project	UXKit
@header		UXSearchBar.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXView.h>

@protocol UXTableViewDataSource, UXSearchTextFieldDelegate;
@class UXSearchTextField, UXButton;

/*!
@class UXSearchBar
@superclass UXView
@abstract
@discussion
*/
@interface UXSearchBar : UXView {
	UXSearchTextField *_searchField;
	UXView *_boxView;
	UIColor *_tintColor;
	UXStyle *_textFieldStyle;
	UXButton *_cancelButton;
	BOOL _showsCancelButton;
	BOOL _showsSearchIcon;
}

	@property (nonatomic, assign) id <UITextFieldDelegate> delegate;
	@property (nonatomic, retain) id <UXTableViewDataSource> dataSource;
	@property (nonatomic, copy) NSString *text;
	@property (nonatomic, copy) NSString *placeholder;
	@property (nonatomic, readonly) UITableView *tableView;
	@property (nonatomic, readonly) UXView *boxView;
	@property (nonatomic, retain) UIColor *tintColor;
	@property (nonatomic, retain) UIColor *textColor;
	@property (nonatomic, retain) UIFont *font;
	@property (nonatomic, retain) UXStyle *textFieldStyle;
	@property (nonatomic) UIReturnKeyType returnKeyType;
	@property (nonatomic) CGFloat rowHeight;
	@property (nonatomic, readonly) BOOL editing;
	@property (nonatomic) BOOL searchesAutomatically;
	@property (nonatomic) BOOL showsCancelButton;
	@property (nonatomic) BOOL showsDoneButton;
	@property (nonatomic) BOOL showsDarkScreen;
	@property (nonatomic) BOOL showsSearchIcon;

	-(void) search;

	-(void) showSearchResults:(BOOL)show;

@end
