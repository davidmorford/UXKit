
#import <UXKit/UXTableViewController.h>
#import <UXKit/UXListDataSource.h>
#import <UXKit/UXTableView.h>
#import <UXKit/UXTableItem.h>
#import <UXKit/UXTableItemCell.h>
#import <UXKit/UXActivityLabel.h>
#import <UXKit/UXErrorView.h>
#import <UXKit/UXTableViewDelegate.h>
#import <UXKit/UXSearchDisplayController.h>
#import <UXKit/UXDefaultStyleSheet.h>
#import <UXKit/UXNavigator.h>

static const CGFloat kBannerViewHeight = 22;


@implementation UXTableViewController

	@synthesize tableView			= _tableView;
	@synthesize tableBannerView		= _tableBannerView;
	@synthesize tableOverlayView	= _tableOverlayView;
	@synthesize loadingView			= _loadingView;
	@synthesize errorView			= _errorView; 
	@synthesize emptyView			= _emptyView;
	@synthesize menuView			= _menuView;
	@synthesize dataSource			= _dataSource;
	@synthesize tableViewStyle		= _tableViewStyle;
	@synthesize variableHeightRows	= _variableHeightRows;


	#pragma mark SPI

	-(void) createInterstitialModel {
		self.dataSource = [[[UXTableViewInterstialDataSource alloc] init] autorelease];
	}

	-(NSString *) defaultTitleForLoading {
		return UXLocalizedString(@"Loading...", @"");
	}

	-(void) updateTableDelegate {
		if (!_tableView.delegate) {
			[_tableDelegate release];
			_tableDelegate		= [[self createDelegate] retain];
			// Set to nil before changing or will not have any effect
			_tableView.delegate = nil;
			_tableView.delegate = _tableDelegate;
		}
	}

	-(void) addToOverlayView:(UIView *)view {
		if (!_tableOverlayView) {
			CGRect frame							= [self rectForOverlayView];
			_tableOverlayView						= [[UIView alloc] initWithFrame:frame];
			_tableOverlayView.autoresizesSubviews	= YES;
			_tableOverlayView.autoresizingMask		= (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin);
			NSInteger tableIndex					= [_tableView.superview.subviews indexOfObject:_tableView];
			if (tableIndex != NSNotFound) {
				[_tableView.superview addSubview:_tableOverlayView];
			}
		}
		view.frame				= _tableOverlayView.bounds;
		view.autoresizingMask	= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[_tableOverlayView addSubview:view];
	}

	-(void) addErrorToOverlayView:(UIView *)view {
		if (!_tableOverlayView) {
			CGRect frame = [_tableView frame];
			_tableOverlayView						= [[UIView alloc] initWithFrame:frame];
			_tableOverlayView.autoresizesSubviews	= YES;
			_tableOverlayView.autoresizingMask		= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
			NSInteger tableIndex					= [_tableView.superview.subviews indexOfObject:_tableView];
			if (tableIndex != NSNotFound) {
				[_tableView.superview addSubview:_tableOverlayView];
			}
		}
		
		view.frame				= _tableOverlayView.bounds;
		view.autoresizingMask	= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[_tableOverlayView addSubview:view];
	}

	-(void) resetOverlayView {
		if (_tableOverlayView && !_tableOverlayView.subviews.count) {
			[_tableOverlayView removeFromSuperview];
			UX_SAFE_RELEASE(_tableOverlayView);
		}
	}

	-(void) layoutOverlayView {
		if (_tableOverlayView) {
			_tableOverlayView.frame = [self rectForOverlayView];
		}
	}

	-(void) layoutBannerView {
		if (_tableBannerView) {
			_tableBannerView.frame = [self rectForBannerView];
		}
	}

	-(void) fadeOutView:(UIView *)view {
		[view retain];
		[UIView beginAnimations:nil context:view];
		[UIView setAnimationDuration:UX_TRANSITION_DURATION];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(fadingOutViewDidStop:finished:context:)];
		view.alpha = 0;
		[UIView commitAnimations];
	}

	-(void) fadingOutViewDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
		UIView *view = (UIView *)context;
		[view removeFromSuperview];
		[view release];
	}

	-(void) hideMenuAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
		UIView *menuView = (UIView *)context;
		[menuView removeFromSuperview];
	}

	
	#pragma mark @UITableViewController

	-(id) initWithStyle:(UITableViewStyle)style {
		if (self = [super init]) {
			_tableView			= nil;
			_tableBannerView	= nil;
			_tableOverlayView	= nil;
			_loadingView		= nil;
			_errorView			= nil;
			_emptyView			= nil;
			_menuView			= nil;
			_menuCell			= nil;
			_dataSource			= nil;
			_tableDelegate		= nil;
			_bannerTimer		= nil;
			_variableHeightRows = NO;
			_tableViewStyle		= style;
			_lastInterfaceOrientation = self.interfaceOrientation;
		}
		return self;
	}


	#pragma mark <NSObject>

	-(id) init {
		return [self initWithStyle:UITableViewStylePlain];
	}

	-(void) dealloc {
		_tableView.delegate		= nil;
		_tableView.dataSource	= nil;
		UX_SAFE_RELEASE(_menuView);
		UX_SAFE_RELEASE(_menuCell);
		UX_SAFE_RELEASE(_tableDelegate);
		UX_SAFE_RELEASE(_dataSource);
		UX_SAFE_RELEASE(_tableView);
		UX_SAFE_RELEASE(_loadingView);
		UX_SAFE_RELEASE(_errorView);
		UX_SAFE_RELEASE(_emptyView);
		UX_SAFE_RELEASE(_tableOverlayView);
		UX_SAFE_RELEASE(_tableBannerView);
		[super dealloc];
	}

	
	#pragma mark @UIViewController

	-(void) loadView {
		[super loadView];
		self.tableView;
	}

	-(void) viewDidUnload {
		[super viewDidUnload];
		_tableView.delegate		= nil;
		_tableView.dataSource	= nil;
		UX_SAFE_RELEASE(_tableDelegate);
		UX_SAFE_RELEASE(_tableView);
		[_tableBannerView removeFromSuperview];
		UX_SAFE_RELEASE(_tableBannerView);
		[_tableOverlayView removeFromSuperview];
		UX_SAFE_RELEASE(_tableOverlayView);
		[_loadingView removeFromSuperview];
		UX_SAFE_RELEASE(_loadingView);
		[_errorView removeFromSuperview];
		UX_SAFE_RELEASE(_errorView);
		[_emptyView removeFromSuperview];
		UX_SAFE_RELEASE(_emptyView);
		[_menuView removeFromSuperview];
		UX_SAFE_RELEASE(_menuView);
		[_menuCell removeFromSuperview];
		UX_SAFE_RELEASE(_menuCell);
	}

	-(void) viewWillAppear:(BOOL)animated {
		[super viewWillAppear:animated];
		if (_lastInterfaceOrientation != self.interfaceOrientation) {
			_lastInterfaceOrientation = self.interfaceOrientation;
			[_tableView reloadData];
		}
		else if ([_tableView isKindOfClass:[UXTableView class ]]) {
			UXTableView *tableView		= (UXTableView *)_tableView;
			tableView.highlightedLabel	= nil;
		}
		[_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:NO];
	}

	-(void) viewWillDisappear:(BOOL)animated {
		[super viewWillDisappear:animated];
		[self hideMenu:YES];
	}

	-(void) setEditing:(BOOL)editing animated:(BOOL)animated {
		[super setEditing:editing animated:animated];
		[self.tableView setEditing:editing animated:animated];
	}


	#pragma mark (UIXViewController)

	-(BOOL) persistView:(NSMutableDictionary *)state {
		CGFloat scrollY = _tableView.contentOffset.y;
		[state setObject:[NSNumber numberWithFloat:scrollY] forKey:@"scrollOffsetY"];
		return [super persistView:state];
	}

	-(void) restoreView:(NSDictionary *)state {
		CGFloat scrollY = [[state objectForKey:@"scrollOffsetY"] floatValue];
		if (scrollY) {
			CGFloat maxY = _tableView.contentSize.height - _tableView.height;
			if (scrollY <= maxY) {
				_tableView.contentOffset = CGPointMake(0, scrollY);
			}
			else {
				_tableView.contentOffset = CGPointMake(0, maxY);
			}
		}
	}


	
	#pragma mark @UXViewController

	-(void) keyboardDidAppear:(BOOL)animated withBounds:(CGRect)bounds {
		[super keyboardDidAppear:animated withBounds:bounds];
		self.tableView.frame =  UXRectContract(self.tableView.frame, 0, bounds.size.height);
		[self.tableView scrollFirstResponderIntoView];
		[self layoutOverlayView];
		[self layoutBannerView];
	}

	-(void) keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds {
		[super keyboardWillDisappear:animated withBounds:bounds];
		self.tableView.frame = UXRectContract(self.tableView.frame, 0, -bounds.size.height);
	}

	-(void) keyboardDidDisappear:(BOOL)animated withBounds:(CGRect)bounds {
		[super keyboardDidDisappear:animated withBounds:bounds];
		[self layoutOverlayView];
		[self layoutBannerView];
	}


	#pragma mark @UXModelViewController

	-(void) beginUpdates {
		[super beginUpdates];
		[_tableView beginUpdates];
	}

	-(void) endUpdates {
		[super endUpdates];
		[_tableView endUpdates];
	}

	-(BOOL) canShowModel {
		if ([_dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
			NSInteger numberOfSections = [_dataSource numberOfSectionsInTableView:_tableView];
			if (!numberOfSections) {
				return NO;
			}
			else if (numberOfSections == 1) {
				NSInteger numberOfRows = [_dataSource tableView:_tableView numberOfRowsInSection:0];
				return numberOfRows > 0;
			}
			else {
				return YES;
			}
		}
		else {
			NSInteger numberOfRows = [_dataSource tableView:_tableView numberOfRowsInSection:0];
			return numberOfRows > 0;
		}
	}

	-(void) didLoadModel:(BOOL)firstTime {
		[super didLoadModel:firstTime];
		[_dataSource tableViewDidLoadModel:_tableView];
	}

	-(void) didShowModel:(BOOL)firstTime {
		[super didShowModel:firstTime];
		if (firstTime) {
			[_tableView flashScrollIndicators];
		}
	}

	-(void) showModel:(BOOL)show {
		[self hideMenu:YES];
		if (show) {
			[self updateTableDelegate];
			_tableView.dataSource = _dataSource;
		}
		else {
			_tableView.dataSource = nil;
		}
		[_tableView reloadData];
	}

	-(void) showLoading:(BOOL)show {
		if (show) {
			if (!self.model.isLoaded || ![self canShowModel]) {
				NSString *title				= _dataSource ? [_dataSource titleForLoading:NO] : [self defaultTitleForLoading];
				if (title.length) {
					UXActivityLabel *label = [[[UXActivityLabel alloc] initWithStyle:UXActivityLabelStyleWhiteBox] autorelease];
					label.text				= title;
					label.backgroundColor	= _tableView.backgroundColor;
					self.loadingView		= label;
				}
			}
		}
		else {
			self.loadingView = nil;
		}
	}

	-(void) showError:(BOOL)show {
		if (show) {
			if (!self.model.isLoaded || ![self canShowModel]) {
				NSString *title		= [_dataSource titleForError:_modelError];
				NSString *subtitle	= [_dataSource subtitleForError:_modelError];
				UIImage *image		= [_dataSource imageForError:_modelError];
				if (title.length || subtitle.length || image) {
					UXErrorView *errorView = [[[UXErrorView alloc] initWithTitle:title
																			subtitle:subtitle
																			   image:image] autorelease];
					errorView.backgroundColor	= _tableView.backgroundColor;
					self.errorView				= errorView;
				}
				else {
					self.errorView = nil;
				}
				_tableView.dataSource = nil;
				[_tableView reloadData];
			}
		}
		else {
			self.errorView = nil;
		}
	}

	-(void) showEmpty:(BOOL)show {
		if (show) {
			NSString *title		= [_dataSource titleForEmpty];
			NSString *subtitle	= [_dataSource subtitleForEmpty];
			UIImage *image		= [_dataSource imageForEmpty];
			
			if (title.length || subtitle.length || image) {
				UXErrorView *errorView	= [[[UXErrorView alloc] initWithTitle:title subtitle:subtitle image:image] autorelease];
				errorView.backgroundColor	= _tableView.backgroundColor;
				self.emptyView				= errorView;
			}
			else {
				self.emptyView = nil;
			}
			_tableView.dataSource = nil;
			[_tableView reloadData];
		}
		else {
			self.emptyView = nil;
		}
	}

	
	#pragma mark <UXModelDelegate>

	-(void) model:(id <UXModel>)model didUpdateObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
		if (model == _model) {
			if (_isViewAppearing && _flags.isShowingModel) {
				if ([_dataSource respondsToSelector:@selector(tableView:willUpdateObject:atIndexPath:)]) {
					NSIndexPath *newIndexPath = [_dataSource tableView:_tableView willUpdateObject:object atIndexPath:indexPath];
					if (newIndexPath) {
						if (newIndexPath.length == 1) {
							UXLOG(@"UPDATING SECTION AT %@", newIndexPath);
							NSInteger sectionIndex = [newIndexPath indexAtPosition:0];
							[_tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationTop];
						}
						else if (newIndexPath.length == 2)  {
							UXLOG(@"UPDATING ROW AT %@", newIndexPath);
							[_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
						}
						[self invalidateView];
					}
					else {
						[_tableView reloadData];
					}
				}
			}
			else {
				[self refresh];
			}
		}
	}

	-(void) model:(id <UXModel>)model didInsertObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
		if (model == _model) {
			if (_isViewAppearing && _flags.isShowingModel) {
				if ([_dataSource respondsToSelector:@selector(tableView:willInsertObject:atIndexPath:)]) {
					NSIndexPath *newIndexPath = [_dataSource tableView:_tableView willInsertObject:object atIndexPath:indexPath];
					if (newIndexPath) {
						if (newIndexPath.length == 1) {
							UXLOG(@"INSERTING SECTION AT %@", newIndexPath);
							NSInteger sectionIndex = [newIndexPath indexAtPosition:0];
							[_tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] 
									  withRowAnimation:UITableViewRowAnimationTop];
						}
						else if (newIndexPath.length == 2)  {
							UXLOG(@"INSERTING ROW AT %@", newIndexPath);
							[_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] 
											  withRowAnimation:UITableViewRowAnimationTop];
							[_tableView scrollToRowAtIndexPath:newIndexPath
											  atScrollPosition:UITableViewScrollPositionTop  
													  animated:NO];
						}
						[self invalidateView];
					}
					else {
						[_tableView reloadData];
					}
				}
			}
			else {
				[self refresh];
			}
		}
	}

	-(void) model:(id <UXModel>)model didDeleteObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
		if (model == _model) {
			if (_isViewAppearing && _flags.isShowingModel) {
				if ([_dataSource respondsToSelector:@selector(tableView:willRemoveObject:atIndexPath:)]) {
					NSIndexPath *newIndexPath = [_dataSource tableView:_tableView willRemoveObject:object atIndexPath:indexPath];
					if (newIndexPath) {
						if (newIndexPath.length == 1) {
							UXLOG(@"DELETING SECTION AT %@", newIndexPath);
							NSInteger sectionIndex = [newIndexPath indexAtPosition:0];
							[_tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationTop];
						}
						else if (newIndexPath.length == 2)  {
							UXLOG(@"DELETING ROW AT %@", newIndexPath);
							[_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
						}
						[self invalidateView];
					}
					else {
						[_tableView reloadData];
					}
				}
			}
			else {
				[self refresh];
			}
		}
	}


	#pragma mark API

	-(UITableView *) tableView {
		if (!_tableView) {
			_tableView						= [[UXTableView alloc] initWithFrame:self.view.bounds style:_tableViewStyle];
			_tableView.autoresizingMask		=  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			UIColor *backgroundColor		= _tableViewStyle == UITableViewStyleGrouped ? UXSTYLESHEETPROPERTY(tableGroupedBackgroundColor) : UXSTYLESHEETPROPERTY(tablePlainBackgroundColor);
			if (backgroundColor) {
				_tableView.backgroundColor	= backgroundColor;
				  self.view.backgroundColor = backgroundColor;
			}
			[self.view addSubview:_tableView];
		}
		return _tableView;
	}

	-(void) setTableView:(UITableView *)tableView {
		if (tableView != _tableView) {
			[_tableView release];
			_tableView = [tableView retain];
			if (!_tableView) {
				self.tableBannerView	= nil;
				self.tableOverlayView	= nil;
			}
		}
	}

	-(void) setTableBannerView:(UIView *)tableBannerView {
		[self setTableBannerView:tableBannerView animated:YES];
	}

	-(void) setTableBannerView:(UIView *)tableBannerView animated:(BOOL)animated {
		UX_INVALIDATE_TIMER(_bannerTimer);
		if (tableBannerView != _tableBannerView) {
			if (_tableBannerView) {
				if (animated) {
					[self fadeOutView:_tableBannerView];
				}
				else {
					[_tableBannerView removeFromSuperview];
				}
			}
			
			[_tableBannerView release];
			_tableBannerView = [tableBannerView retain];
			
			if (_tableBannerView) {
				_tableBannerView.frame					= [self rectForBannerView];
				_tableBannerView.userInteractionEnabled = NO;
				[self addToOverlayView:_tableBannerView];
				
				if (animated) {
					_tableBannerView.top += kBannerViewHeight;
					[UIView beginAnimations:nil context:nil];
					[UIView setAnimationDuration:UX_TRANSITION_DURATION];
					[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
					_tableBannerView.top -= kBannerViewHeight;
					[UIView commitAnimations];
				}
			}
		}
	}

	-(void) setTableOverlayView:(UIView *)tableOverlayView animated:(BOOL)animated {
		if (tableOverlayView != _tableOverlayView) {
			if (_tableOverlayView) {
				if (animated) {
					[self fadeOutView:_tableOverlayView];
				}
				else {
					[_tableOverlayView removeFromSuperview];
				}
			}
			
			[_tableOverlayView release];
			_tableOverlayView = [tableOverlayView retain];
			
			if (_tableOverlayView) {
				_tableOverlayView.frame = [self rectForOverlayView];
				[self addToOverlayView:_tableOverlayView];
			}
			
			// There seem to be cases where this gets left disable - must investigate
			//_tableView.scrollEnabled = !_tableOverlayView;
		}
	}

	-(void) setDataSource:(id <UXTableViewDataSource>)dataSource {
		if (dataSource != _dataSource) {
			[_dataSource release];
			_dataSource = [dataSource retain];
			_tableView.dataSource = nil;
			self.model	= dataSource.model;
		}
	}

	-(void) setVariableHeightRows:(BOOL)variableHeightRows {
		if (variableHeightRows != _variableHeightRows) {
			_variableHeightRows = variableHeightRows;
			// Force the delegate to be re-created so that it supports the right kind of row measurement
			_tableView.delegate = nil;
		}
	}

	-(void) setLoadingView:(UIView *)view {
		if (view != _loadingView) {
			if (_loadingView) {
				[_loadingView removeFromSuperview];
				UX_SAFE_RELEASE(_loadingView);
			}
			_loadingView = [view retain];
			if (_loadingView) {
				[self addToOverlayView:_loadingView];
			}
			else {
				[self resetOverlayView];
			}
		}
	}

	-(void) setErrorView:(UIView *)view {
		if (view != _errorView) {
			if (_errorView) {
				[_errorView removeFromSuperview];
				UX_SAFE_RELEASE(_errorView);
			}
			_errorView = [view retain];
			
			if (_errorView) {
				/*[self addToOverlayView:_errorView];*/
				[self addErrorToOverlayView:_errorView];
			}
			else {
				[self resetOverlayView];
			}
		}
	}

	-(void) setEmptyView:(UIView *)view {
		if (view != _emptyView) {
			if (_emptyView) {
				[_emptyView removeFromSuperview];
				UX_SAFE_RELEASE(_emptyView);
			}
			_emptyView = [view retain];
			if (_emptyView) {
				[self addToOverlayView:_emptyView];
			}
			else {
				[self resetOverlayView];
			}
		}
	}

	-(id <UITableViewDelegate>) createDelegate {
		if (_variableHeightRows) {
			return [[[UXTableViewVarHeightDelegate alloc] initWithController:self] autorelease];
		}
		else {
			return [[[UXTableViewDelegate alloc] initWithController:self] autorelease];
		}
	}

	-(void) showMenu:(UIView *)view forCell:(UITableViewCell *)cell animated:(BOOL)animated {
		[self hideMenu:YES];
		
		_menuView = [view retain];
		_menuCell = [cell retain];
		
		// Insert the cell below all content subviews
		[_menuCell.contentView insertSubview:_menuView atIndex:0];
		
		if (animated) {
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:UX_FAST_TRANSITION_DURATION];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		}
		
		// Move each content subview down, revealing the menu
		for (UIView *view in _menuCell.contentView.subviews) {
			if (view != _menuView) {
				view.left -= _menuCell.contentView.width;
			}
		}
		
		if (animated) {
			[UIView commitAnimations];
		}
	}

	-(void) hideMenu:(BOOL)animated {
		if (_menuView) {
			if (animated) {
				[UIView beginAnimations:nil context:_menuView];
				[UIView setAnimationDuration:UX_FAST_TRANSITION_DURATION];
				[UIView setAnimationDelegate:self];
				[UIView setAnimationDidStopSelector:@selector(hideMenuAnimationDidStop:finished:context:)];
			}
			
			for (UIView *view in _menuCell.contentView.subviews) {
				if (view != _menuView) {
					view.left += _menuCell.contentView.width;
				}
			}
			
			if (animated) {
				[UIView commitAnimations];
			}
			else {
				[_menuView removeFromSuperview];
			}
			
			UX_SAFE_RELEASE(_menuView);
			UX_SAFE_RELEASE(_menuCell);
		}
	}

	-(void) didSelectObject:(id)anObject atIndexPath:(NSIndexPath *)anIndexPath {
		if ([anObject respondsToSelector:@selector(URLValue)]) {
			NSString *URL = [anObject URLValue];
			if (URL) {
				UXOpenURL(URL);
			}
		}
	}

	-(BOOL) shouldOpenURL:(NSString *)URL {
		return YES;
	}

	-(void) didBeginDragging {
		[self hideMenu:YES];
	}

	-(void) didEndDragging {
	}

	-(CGRect) rectForOverlayView {
		return [_tableView frameWithKeyboardSubtracted:0];
	}

	-(CGRect) rectForBannerView {
		CGRect tableFrame = [_tableView frameWithKeyboardSubtracted:0];
		UXLOG(@"rectForBannerView = %@", NSStringFromCGRect(tableFrame));
		tableFrame = CGRectMake(tableFrame.origin.x, (tableFrame.origin.y + tableFrame.size.height) - kBannerViewHeight, tableFrame.size.width, kBannerViewHeight);
		UXLOG(@"rectForBannerView = %@", NSStringFromCGRect(tableFrame));
		return tableFrame;
	}

@end
