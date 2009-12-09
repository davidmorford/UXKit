
#import <UXKit/UXSearchBar.h>
#import <UXKit/UXSearchTextField.h>
#import <UXKit/UXView.h>
#import <UXKit/UXDefaultStyleSheet.h>
#import <UXKit/UXButton.h>
#import <UXKit/UIXView.h>

static const CGFloat kMarginX = 5;
static const CGFloat kMarginY = 7;
static const CGFloat kPaddingX = 10;
static const CGFloat kPaddingY = 10;
static const CGFloat kSpacingX = 4;
static const CGFloat kButtonHeight		= 30;
static const CGFloat kButtonSpacing		= 12;
static const CGFloat kIndexViewMargin	= 4;

#pragma mark -

@implementation UXSearchBar

	@synthesize boxView = _boxView;
	@synthesize tintColor = _tintColor;
	@synthesize textFieldStyle = _textFieldStyle;
	@synthesize showsCancelButton = _showsCancelButton;
	@synthesize showsSearchIcon = _showsSearchIcon;


	#pragma mark -

	-(CGFloat) indexViewWidth {
		UITableView *tableView = (UITableView *)[self ancestorOrSelfWithClass:[UITableView class]];
		if (tableView) {
			UIView *indexView = tableView.indexView;
			if (indexView) {
				return indexView.width;
			}
		}
		return 0;
	}

	-(void) showIndexView:(BOOL)show {
		UITableView *tableView = (UITableView *)[self ancestorOrSelfWithClass:[UITableView class]];
		if (tableView) {
			UIView *indexView = tableView.indexView;
			if (indexView) {
				[UIView beginAnimations:nil context:nil];
				[UIView setAnimationDuration:UX_TRANSITION_DURATION];
				
				if (show) {
					CGRect frame	= indexView.frame;
					frame.origin.x	= self.width - (indexView.width + kIndexViewMargin);
					indexView.frame = frame;
				}
				else {
					indexView.frame = CGRectOffset(indexView.frame, indexView.width + kIndexViewMargin, 0);
				}
				indexView.alpha			= show ? 1 : 0;
				
				CGRect searchFrame		= _searchField.frame;
				searchFrame.size.width	+= show ? -self.indexViewWidth : self.indexViewWidth;
				_searchField.frame		= searchFrame;
				
				CGRect boxFrame			= _boxView.frame;
				boxFrame.size.width		+= show ? -self.indexViewWidth : self.indexViewWidth;
				_boxView.frame			= boxFrame;
				
				[UIView commitAnimations];
			}
		}
	}

	-(void) scrollToTop {
		UIScrollView *scrollView	= (UIScrollView *)[self ancestorOrSelfWithClass:[UIScrollView class]];
		if (scrollView) {
			CGPoint offset			= scrollView.contentOffset;
			CGPoint myOffset		= [self offsetFromView:scrollView];
			if (offset.y != myOffset.y) {
				[scrollView setContentOffset:CGPointMake(offset.x, myOffset.y) animated:YES];
			}
		}
	}

	-(void) textFieldDidBeginEditing {
		[self scrollToTop];
		[self showIndexView:NO];
	}

	-(void) textFieldDidEndEditing {
		[self showIndexView:YES];
	}


	#pragma mark NSObject

	-(id) initWithFrame:(CGRect)frame {
		if (self = [super initWithFrame:frame]) {
			_boxView							= [[UXView alloc] init];
			_boxView.backgroundColor			= [UIColor clearColor];
			[self addSubview:_boxView];
			_searchField						= [[UXSearchTextField alloc] init];
			_searchField.placeholder			= UXLocalizedString(@"Search", @"");
			_searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;
			
			[_searchField addTarget:self action:@selector(textFieldDidBeginEditing) forControlEvents:UIControlEventEditingDidBegin];
			[_searchField addTarget:self action:@selector(textFieldDidEndEditing) forControlEvents:UIControlEventEditingDidEnd];
			
			[self addSubview:_searchField];
			
			self.tintColor			= UXSTYLESHEETPROPERTY(searchBarTintColor);
			self.style				= UXSTYLEWITHSELECTOR(searchBar);
			self.textFieldStyle		= UXSTYLEWITHSELECTOR(searchTextField);
			self.font				= UXSTYLESHEETPROPERTY(font);
			self.showsSearchIcon	= YES;
			self.showsCancelButton	= NO;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_searchField);
		UX_SAFE_RELEASE(_boxView);
		UX_SAFE_RELEASE(_textFieldStyle);
		UX_SAFE_RELEASE(_tintColor);
		UX_SAFE_RELEASE(_cancelButton);
		[super dealloc];
	}


	#pragma mark UIResponder

	-(BOOL) becomeFirstResponder {
		return [_searchField becomeFirstResponder];
	}

	-(BOOL) resignFirstResponder {
		return [_searchField resignFirstResponder];
	}


	#pragma mark UIView

	-(void) layoutSubviews {
		CGFloat indexViewWidth	= [_searchField isEditing] ? 0 : self.indexViewWidth;
		CGFloat leftPadding		= _showsSearchIcon ? 0 : kSpacingX;
		
		CGFloat buttonWidth = 0;
		if (_showsCancelButton) {
			[_cancelButton sizeToFit];
			buttonWidth = _cancelButton.width + kButtonSpacing;
		}
		
		CGFloat boxHeight		= self.font.lineHeight + 8;
		_boxView.frame			= CGRectMake(kMarginX, floor(self.height / 2 - boxHeight / 2), self.width - (kMarginX * 2 + indexViewWidth + buttonWidth), boxHeight);
		_searchField.frame		= CGRectMake(kMarginX + kPaddingX + leftPadding, 0, self.width - (kMarginX * 2 + kPaddingX + leftPadding + buttonWidth + indexViewWidth), self.height);
		
		if (_showsCancelButton) {
			_cancelButton.frame	= CGRectMake(_boxView.right + kButtonSpacing, floor(self.height / 2 - kButtonHeight / 2), _cancelButton.width, kButtonHeight);
		}
	}


	-(CGSize) sizeThatFits:(CGSize)size {
		CGFloat height = self.font.lineHeight + kPaddingY * 2;
		if (height < UX_ROW_HEIGHT) {
			height = UX_ROW_HEIGHT;
		}
		return CGSizeMake(size.width, height);
	}


	#pragma mark API

	-(id <UITextFieldDelegate>) delegate {
		return _searchField.delegate;
	}

	-(void) setDelegate:(id <UITextFieldDelegate>)aDelegate {
		_searchField.delegate = aDelegate;
	}

	-(id <UXTableViewDataSource>) dataSource {
		return _searchField.dataSource;
	}

	-(void) setDataSource:(id <UXTableViewDataSource>)aDataSource {
		_searchField.dataSource = aDataSource;
	}

	-(BOOL) editing {
		return _searchField.editing;
	}

	-(BOOL) showsDoneButton {
		return _searchField.showsDoneButton;
	}

	-(void) setShowsDoneButton:(BOOL)showsDoneButton {
		_searchField.showsDoneButton = showsDoneButton;
	}

	-(BOOL) showsDarkScreen {
		return _searchField.showsDarkScreen;
	}

	-(void) setShowsDarkScreen:(BOOL)showsDarkScreen {
		_searchField.showsDarkScreen = showsDarkScreen;
	}

	-(void) setShowsCancelButton:(BOOL)showsCancelButton {
		if (showsCancelButton != _showsCancelButton) {
			_showsCancelButton = showsCancelButton;
			
			if (_showsCancelButton) {
				_cancelButton = [[UXButton buttonWithStyle:@"blackToolbarButton:" title:UXLocalizedString(@"Cancel", @"")] retain];
				[_cancelButton addTarget:_searchField 
								  action:@selector(resignFirstResponder) 
						forControlEvents:UIControlEventTouchUpInside];
				[self addSubview:_cancelButton];
			}
			else {
				[_cancelButton removeFromSuperview];
				UX_SAFE_RELEASE(_cancelButton);
			}
		}
	}

	-(void) setShowsSearchIcon:(BOOL)showsSearchIcon {
		if (showsSearchIcon != _showsSearchIcon) {
			_showsSearchIcon = showsSearchIcon;
			
			if (_showsSearchIcon) {
				UIImageView *iconView		= [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UXKit.bundle/Images/Search/searchIcon.png"]] autorelease];
				[iconView sizeToFit];
				iconView.contentMode		= UIViewContentModeLeft;
				iconView.frame				= CGRectInset(iconView.frame, -floor(kMarginX / 2), 0);
				_searchField.leftView		= iconView;
				_searchField.leftViewMode	= UITextFieldViewModeAlways;
			}
			else {
				_searchField.leftView		= nil;
				_searchField.leftViewMode	= UITextFieldViewModeNever;
			}
		}
	}

	-(BOOL) searchesAutomatically {
		return _searchField.searchesAutomatically;
	}

	-(void) setSearchesAutomatically:(BOOL)searchesAutomatically {
		_searchField.searchesAutomatically = searchesAutomatically;
	}

	-(NSString *) text {
		return _searchField.text;
	}

	-(void) setText:(NSString *)text {
		_searchField.text = text;
	}

	-(NSString *) placeholder {
		return _searchField.placeholder;
	}

	-(void) setPlaceholder:(NSString *)placeholder {
		_searchField.placeholder = placeholder;
	}

	-(UITableView *) tableView {
		return _searchField.tableView;
	}

	-(void) setTintColor:(UIColor *)tintColor {
		if (tintColor != _tintColor) {
			[_tintColor release];
			_tintColor = [tintColor retain];
		}
	}

	-(void) setTextFieldStyle:(UXStyle *)textFieldStyle {
		if (textFieldStyle != _textFieldStyle) {
			[_textFieldStyle release];
			_textFieldStyle = [textFieldStyle retain];
			_boxView.style	= _textFieldStyle;
		}
	}

	-(UIColor *) textColor {
		return _searchField.textColor;
	}

	-(void) setTextColor:(UIColor *)textColor {
		_searchField.textColor = textColor;
	}

	-(UIFont *) font {
		return _searchField.font;
	}

	-(void) setFont:(UIFont *)font {
		_searchField.font = font;
	}

	-(CGFloat) rowHeight {
		return _searchField.rowHeight;
	}

	-(void) setRowHeight:(CGFloat)rowHeight {
		_searchField.rowHeight = rowHeight;
	}

	-(UIReturnKeyType) returnKeyType {
		return _searchField.returnKeyType;
	}

	-(void) setReturnKeyType:(UIReturnKeyType)returnKeyType {
		_searchField.returnKeyType = returnKeyType;
	}

	-(void) search {
		[_searchField search];
	}

	-(void) showSearchResults:(BOOL)show {
		[_searchField showSearchResults:show];
	}

@end
