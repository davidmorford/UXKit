
#import <UXKit/UXSearchTextField.h>
#import <UXKit/UXNavigator.h>
#import <UXKit/UXView.h>
#import <UXKit/UXDefaultStyleSheet.h>
#import <UXKit/UXTableView.h>
#import <UXKit/UXTableItemCell.h>

static const CGFloat kShadowHeight			= 24;
static const CGFloat kDesiredTableHeight	= 150;

@interface UXSearchTextFieldInternal : NSObject <UITextFieldDelegate> {
	UXSearchTextField *_textField;
	id <UITextFieldDelegate> _delegate;
}

	@property (nonatomic, assign) id <UITextFieldDelegate> delegate;

	-(id) initWithTextField:(UXSearchTextField *)aTextField;

@end

#pragma mark -

@implementation UXSearchTextFieldInternal

	@synthesize delegate = _delegate;

	
	#pragma mark Initializer

	-(id) initWithTextField:(UXSearchTextField *)textField {
		if (self = [super init]) {
			_textField = textField;
		}
		return self;
	}


	#pragma mark <NSObject>

	-(void) dealloc {
		[super dealloc];
	}

	
	#pragma mark <UITextFieldDelegate>

	-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
		if ([_delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
			return [_delegate textFieldShouldBeginEditing:textField];
		}
		else {
			return YES;
		}
	}

	-(void) textFieldDidBeginEditing:(UITextField *)textField {
		if ([_delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
			[_delegate textFieldDidBeginEditing:textField];
		}
	}

	-(BOOL) textFieldShouldEndEditing:(UITextField *)textField {
		if ([_delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
			return [_delegate textFieldShouldEndEditing:textField];
		}
		else {
			return YES;
		}
	}

	-(void) textFieldDidEndEditing:(UITextField *)textField {
		if ([_delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
			[_delegate textFieldDidEndEditing:textField];
		}
	}

	-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
		if (![_textField shouldUpdate:!string.length]) {
			return NO;
		}
		
		SEL sel = @selector(textField : shouldChangeCharactersInRange : replacementString :);
		if ([_delegate respondsToSelector:sel]) {
			return [_delegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
		}
		else {
			return YES;
		}
	}

	-(BOOL) textFieldShouldClear:(UITextField *)textField {
		[_textField shouldUpdate:YES];
		
		if ([_delegate respondsToSelector:@selector(textFieldShouldClear:)]) {
			return [_delegate textFieldShouldClear:textField];
		}
		else {
			return YES;
		}
	}

	-(BOOL) textFieldShouldReturn:(UITextField *)textField {
		BOOL shouldReturn = YES;
		if ([_delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
			shouldReturn = [_delegate textFieldShouldReturn:textField];
		}
		
		if (shouldReturn) {
			if (!_textField.searchesAutomatically) {
				[_textField search];
			}
			else {
				[_textField performSelector:@selector(doneAction)];
			}
		}
		return shouldReturn;
	}

@end

#pragma mark -

@implementation UXSearchTextField

	@synthesize dataSource = _dataSource;
	@synthesize tableView = _tableView; 
	@synthesize rowHeight = _rowHeight;
	@synthesize searchesAutomatically = _searchesAutomatically;
	@synthesize showsDoneButton = _showsDoneButton;
	@synthesize showsDarkScreen = _showsDarkScreen;

	#pragma mark @UIView

	-(id) initWithFrame:(CGRect)frame {
		if (self = [super initWithFrame:frame]) {
			_internal		= [[UXSearchTextFieldInternal alloc] initWithTextField:self];
			_dataSource		= nil;
			_tableView		= nil;
			_shadowView		= nil;
			_screenView		= nil;
			_searchTimer	= nil;
			_previousNavigationItem		= nil;
			_previousRightBarButtonItem = nil;
			_rowHeight			= 0;
			_showsDoneButton	= NO;
			_showsDarkScreen	= NO;
			
			self.autocorrectionType			= UITextAutocorrectionTypeNo;
			self.contentVerticalAlignment	= UIControlContentVerticalAlignmentCenter;
			self.clearButtonMode			= UITextFieldViewModeWhileEditing;
			self.searchesAutomatically		= YES;
			
			[self addTarget:self action:@selector(didBeginEditing) forControlEvents:UIControlEventEditingDidBegin];
			[self addTarget:self action:@selector(didEndEditing) forControlEvents:UIControlEventEditingDidEnd];
			
			[super setDelegate:_internal];
		}
		return self;
	}


	#pragma mark <NSObject>

	-(void) dealloc {
		[_dataSource.model.delegates removeObject:self];
		_tableView.delegate = nil;
		UX_SAFE_RELEASE(_dataSource);
		UX_SAFE_RELEASE(_internal);
		UX_SAFE_RELEASE(_tableView);
		UX_SAFE_RELEASE(_shadowView);
		UX_SAFE_RELEASE(_screenView);
		UX_SAFE_RELEASE(_previousNavigationItem);
		UX_SAFE_RELEASE(_previousRightBarButtonItem);
		[super dealloc];
	}


	#pragma mark SPI

	-(void) showDoneButton:(BOOL)show {
		UIViewController *controller = [UXNavigator navigator].visibleViewController;
		if (controller) {
			if (show) {
				_previousNavigationItem		= [controller.navigationItem retain];
				_previousRightBarButtonItem = [controller.navigationItem.rightBarButtonItem retain];
				UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)] autorelease];
				[controller.navigationItem setRightBarButtonItem:doneButton animated:YES];
			}
			else {
				[_previousNavigationItem setRightBarButtonItem:_previousRightBarButtonItem animated:YES];
				UX_SAFE_RELEASE(_previousRightBarButtonItem);
				UX_SAFE_RELEASE(_previousNavigationItem);
			}
		}
	}

	-(void) showDarkScreen:(BOOL)show {
		if (show && !_screenView) {
			_screenView					= [[UIButton buttonWithType:UIButtonTypeCustom] retain];
			_screenView.backgroundColor = UXSTYLEVAR(screenBackgroundColor);
			_screenView.frame			= [self rectForSearchResults:NO];
			_screenView.alpha			= 0;
			[_screenView addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
		}
		
		if (show) {
			[self.superviewForSearchResults addSubview:_screenView];
		}
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:UX_TRANSITION_DURATION];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(screenAnimationDidStop)];
		
		_screenView.alpha = show ? 1 : 0;
		
		[UIView commitAnimations];
	}

	-(NSString *) searchText {
		if (!self.hasText) {
			return @"";
		}
		else {
			NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
			return [self.text stringByTrimmingCharactersInSet:whitespace];
		}
	}

	-(void) autoSearch {
		if (_searchesAutomatically || !self.text.length) {
			[self search];
		}
	}

	-(void) dispatchUpdate:(NSTimer *)timer {
		_searchTimer = nil;
		[self autoSearch];
	}

	-(void) delayedUpdate {
		[_searchTimer invalidate];
		_searchTimer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(dispatchUpdate:) userInfo:nil repeats:NO];
	}

	-(BOOL) hasSearchResults {
		return (![_dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)] || [_dataSource numberOfSectionsInTableView:_tableView]) && [_dataSource tableView:_tableView numberOfRowsInSection:0];
	}

	-(void) reloadTable {
		[_dataSource tableViewDidLoadModel:self.tableView];
		if ([self hasSearchResults]) {
			[self layoutIfNeeded];
			[self showSearchResults:YES];
			[self.tableView reloadData];
		}
		else {
			[self showSearchResults:NO];
		}
	}

	-(void) screenAnimationDidStop {
		if (_screenView.alpha == 0) {
			[_screenView removeFromSuperview];
		}
	}

	-(void) doneAction {
		[self resignFirstResponder];
		
		if (self.dataSource) {
			self.text = @"";
		}
	}


	#pragma mark @UITextField

	-(id <UITextFieldDelegate>) delegate {
		return _internal.delegate;
	}

	-(void) setDelegate:(id <UITextFieldDelegate>)delegate {
		_internal.delegate = delegate;
	}

	-(void) setText:(NSString *)text {
		[super setText:text];
		[self autoSearch];
	}


	#pragma mark <UITableViewDelegate>

	-(CGFloat) tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)anIndexPath {
		if (_rowHeight) {
			return _rowHeight;
		}
		else {
			id object = [_dataSource tableView:aTableView objectForRowAtIndexPath:anIndexPath];
			Class cls = [_dataSource tableView:aTableView cellClassForObject:object];
			return [cls tableView:_tableView rowHeightForObject:object];
		}
	}

	-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		if ([_internal.delegate respondsToSelector:@selector(textField:didSelectObject:)]) {
			id object = [_dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
			UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
			if (cell.selectionStyle != UITableViewCellSeparatorStyleNone) {
				[_internal.delegate performSelector:@selector(textField:didSelectObject:) withObject:self withObject:object];
			}
		}
	}


	#pragma mark <UXModelDelegate>

	-(void) modelDidStartLoad:(id <UXModel>)aModel {
		if (!_searchesAutomatically) {
			[self reloadTable];
		}
	}

	-(void) modelDidFinishLoad:(id <UXModel>)aModel {
		[self reloadTable];
	}

	-(void) modelDidChange:(id <UXModel>)aModel {
		[self reloadTable];
	}


	-(void) model:(id <UXModel>)aModel didFailLoadWithError:(NSError *)anError {
		[self reloadTable];
	}


	#pragma mark UIControlEvents

	-(void) didBeginEditing {
		if (_dataSource) {
			UIScrollView *scrollView	= (UIScrollView *)[self ancestorOrSelfWithClass:[UIScrollView class]];
			scrollView.scrollEnabled	= NO;
			scrollView.scrollsToTop		= NO;
			
			if (_showsDoneButton) {
				[self showDoneButton:YES];
			}
			if (_showsDarkScreen) {
				[self showDarkScreen:YES];
			}
			if (self.hasText && self.hasSearchResults) {
				[self showSearchResults:YES];
			}
		}
	}

	-(void) didEndEditing {
		if (_dataSource) {
			UIScrollView *scrollView	= (UIScrollView *)[self ancestorOrSelfWithClass:[UIScrollView class]];
			scrollView.scrollEnabled	= YES;
			scrollView.scrollsToTop		= YES;
			
			[self showSearchResults:NO];
			
			if (_showsDoneButton) {
				[self showDoneButton:NO];
			}
			if (_showsDarkScreen) {
				[self showDarkScreen:NO];
			}
		}
	}


	#pragma mark API

	-(void) setDataSource:(id <UXTableViewDataSource>)dataSource {
		if (dataSource != _dataSource) {
			[_dataSource.model.delegates removeObject:self];
			[_dataSource release];
			_dataSource = [dataSource retain];
			[_dataSource.model.delegates addObject:self];
		}
	}

	-(UITableView *) tableView {
		if (!_tableView) {
			_tableView					= [[UXTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
			_tableView.backgroundColor	= UXSTYLEVAR(searchTableBackgroundColor);
			_tableView.separatorColor	= UXSTYLEVAR(searchTableSeparatorColor);
			_tableView.rowHeight		= _rowHeight;
			_tableView.dataSource		= _dataSource;
			_tableView.delegate			= self;
			_tableView.scrollsToTop		= NO;
		}
		
		return _tableView;
	}

	-(void) setSearchesAutomatically:(BOOL)searchesAutomatically {
		_searchesAutomatically = searchesAutomatically;
		if (searchesAutomatically) {
			self.returnKeyType					= UIReturnKeyDone;
			self.enablesReturnKeyAutomatically	= NO;
		}
		else {
			self.returnKeyType					= UIReturnKeySearch;
			self.enablesReturnKeyAutomatically	= YES;
		}
	}

	-(BOOL) hasText {
		return self.text.length;
	}

	-(void) search {
		if (_dataSource) {
			NSString *text = self.searchText;
			[_dataSource search:text];
		}
	}

	-(void) showSearchResults:(BOOL)show {
		if (show && _dataSource) {
			self.tableView;
			
			if (!_shadowView) {
				_shadowView							= [[UXView alloc] init];
				_shadowView.style					= UXSTYLE(searchTableShadow);
				_shadowView.backgroundColor			= [UIColor clearColor];
				_shadowView.userInteractionEnabled	= NO;
			}
			
			if (!_tableView.superview) {
				_tableView.frame	= [self rectForSearchResults:YES];
				_shadowView.frame	= CGRectMake(_tableView.left, _tableView.top - 1, _tableView.width, kShadowHeight);
				
				UIView *superview	= self.superviewForSearchResults;
				[superview addSubview:_tableView];
				
				if (_tableView.separatorStyle != UITableViewCellSeparatorStyleNone) {
					[superview addSubview:_shadowView];
				}
			}
			
			[_tableView deselectRowAtIndexPath:_tableView.indexPathForSelectedRow animated:NO];
		}
		else {
			[_tableView removeFromSuperview];
			[_shadowView removeFromSuperview];
		}
	}

	-(UIView *) superviewForSearchResults {
		UIScrollView *scrollView = (UIScrollView *)[self ancestorOrSelfWithClass:[UIScrollView class]];
		if (scrollView) {
			return scrollView;
		}
		else {
			for (UIView *view = self.superview; view; view = view.superview) {
				if (view.height > kDesiredTableHeight) {
					return view;
				}
			}
			
			return self.superview;
		}
	}

	-(CGRect) rectForSearchResults:(BOOL)withKeyboard {
		UIView *superview = self.superviewForSearchResults;
		
		CGFloat y		= 0;
		UIView *view	= self;
		while (view != superview) {
			y	+= view.top;
			view = view.superview;
		}
		
		CGFloat height			= self.height;
		CGFloat keyboardHeight	= withKeyboard ? UXKeyboardHeight() : 0;
		CGFloat tableHeight		= self.window.height - (self.screenY + height + keyboardHeight);
		
		return CGRectMake(0, y + self.height - 1, superview.frame.size.width, tableHeight + 1);
	}

	-(BOOL) shouldUpdate:(BOOL)emptyText {
		[self delayedUpdate];
		return YES;
	}

@end
