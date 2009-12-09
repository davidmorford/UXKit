
#import <UXKit/UXLauncherView.h>
#import <UXKit/UXLauncherItem.h>
#import <UXKit/UXLauncherButton.h>
#import <UXKit/UXPageControl.h>

static const CGFloat kMargin						= 0;
static const CGFloat kPadding						= 0;
static const CGFloat kPromptMargin					= 40;
static const CGFloat kPagerHeight					= 20;
static const CGFloat kWobbleRadians					= 1.5;
static const CGFloat kSpringLoadFraction			= 0.18;

static const NSTimeInterval kEditHoldTimeInterval	= 1;
static const NSTimeInterval kSpringLoadTimeInterval = 0.5;
static const NSTimeInterval kWobbleTime				= 0.07;

static const NSInteger		kPromptTag				= 997;
static const NSInteger		kDefaultColumnCount		= 3;

#pragma mark -

@interface UXLauncherScrollView : UIScrollView
@end

@implementation UXLauncherScrollView

	-(BOOL) touchesShouldCancelInContentView:(UIView *)view {
	  return !self.delaysContentTouches;
	}

@end

#pragma mark -

@implementation UXLauncherView

	@synthesize delegate	= _delegate;
	@synthesize columnCount = _columnCount;
	@synthesize prompt		= _prompt;
	@synthesize editing		= _editing;


	#pragma mark SPI

	-(CGFloat) rowHeight {
		/*
		if (UIInterfaceOrientationIsPortrait(UXInterfaceOrientation())) {
		*/
			return 103;
		/*
		}
		else {
			return 74;
		}
		*/
	}

	-(UXLauncherButton *) buttonForItem:(UXLauncherItem *)item {
		NSIndexPath *path = [self indexPathOfItem:item];
		if (path) {
			NSInteger pageIndex = [path indexAtPosition:0];
			NSArray *buttonPage = [_buttons objectAtIndex:pageIndex];
			NSInteger itemIndex = [path indexAtPosition:1];
			return [buttonPage objectAtIndex:itemIndex];
		}
		else {
			return nil;
		}
	}

	-(NSMutableArray *) pageWithItem:(UXLauncherItem *)item {
		for (NSMutableArray *page in _pages) {
			NSUInteger itemIndex = [page indexOfObject:item];
			if (itemIndex != NSNotFound) {
				return page;
			}
		}
		return nil;
	}

	-(NSMutableArray *) pageWithButton:(UXLauncherButton *)button {
		NSIndexPath *path = [self indexPathOfItem:button.item];
		if (path) {
			NSInteger pageIndex = [path indexAtPosition:0];
			return [_buttons objectAtIndex:pageIndex];
		}
		else {
			return nil;
		}
	}

	-(NSMutableArray *) pageWithFreeSpace:(NSInteger)pageIndex {
		for (NSInteger i = self.currentPageIndex; i < _pages.count; ++i) {
			NSMutableArray *page = [_pages objectAtIndex:i];
			if (page.count < self.columnCount * self.rowCount) {
				return page;
			}
		}
		
		NSMutableArray *page = [NSMutableArray array];
		[_pages addObject:page];
		return page;
	}

	-(void) updateItemBadge:(UXLauncherItem *)item {
		UXLauncherButton *button = [self buttonForItem:item];
		[button performSelector:@selector(updateBadge)];
	}

	-(void) updateContentSize:(NSInteger)numberOfPages {
		_scrollView.contentSize = CGSizeMake(numberOfPages * _scrollView.width, _scrollView.height);
		if (numberOfPages != _pager.numberOfPages) {
			_pager.numberOfPages = numberOfPages;
		}
	}

	-(void) updatePagerWithContentOffset:(CGPoint)contentOffset {
		CGFloat pageWidth	= _scrollView.width;
		_pager.currentPage	= floor((contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	}

	-(void) showPrompt {
		CGRect boxFrame			= CGRectMake(_scrollView.width, 0, _scrollView.width, _scrollView.height);
		CGRect labelFrame		= CGRectInset(boxFrame, kPromptMargin, kPromptMargin);
		UILabel *label			= [[[UILabel alloc] initWithFrame:labelFrame] autorelease];
		label.tag				= kPromptTag;
		label.text				= _prompt;
		label.font				= [UIFont systemFontOfSize:18];
		label.backgroundColor	= [UIColor clearColor];
		label.textColor			= RGBCOLOR(50, 50, 50);
		label.shadowColor		= [UIColor whiteColor];
		label.shadowOffset		= CGSizeMake(1, 1);
		label.textAlignment		= UITextAlignmentCenter;
		label.numberOfLines		= 0;
		[_scrollView addSubview:label];
	}

	-(UXLauncherButton *) addButtonWithItem:(UXLauncherItem *)item {
		UXLauncherButton *button = [[[UXLauncherButton alloc] initWithItem:item] autorelease];
		[button addTarget:self action:@selector(buttonTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
		[button addTarget:self action:@selector(buttonTouchedUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
		[button addTarget:self action:@selector(buttonTouchedDown:withEvent:) forControlEvents:UIControlEventTouchDown];
		[_scrollView addSubview:button];
		return button;
	}

	-(void) layoutButtons {
		[self layoutIfNeeded];
		
		CGFloat buttonWidth		= ceil((self.width - (kMargin * 2 + kPadding * (self.columnCount - 1))) / self.columnCount);
		CGFloat buttonHeight	= [self rowHeight];
		CGFloat pageWidth		= _scrollView.width;
		
		CGFloat x		= kMargin;
		CGFloat minX	= 0;
		
		for (NSMutableArray *buttonPage in _buttons) {
			
			CGFloat y = kMargin;
			
			for (UXLauncherButton *button in buttonPage) {
				
				CGRect frame = CGRectMake(x, y, buttonWidth, buttonHeight);
				
				if (!button.dragging) {
					button.transform	= CGAffineTransformIdentity;
					button.frame		= button == _dragButton ? [_scrollView convertRect:frame toView:self] : frame;
				}
				x += buttonWidth + kPadding;
				if (x >= minX + pageWidth) {
					y += buttonHeight + kPadding;
					x = minX + kMargin;
				}
			}
			minX	+= pageWidth;
			x		= minX;
		}
		
		NSInteger numberOfPages = _pages.count;
		if ((numberOfPages == 1) && _prompt) {
			[self showPrompt];
			++numberOfPages;
		}
		[self updateContentSize:numberOfPages];
	}

	-(void) recreateButtons {
		[self layoutIfNeeded];
		[_scrollView removeAllSubviews];
		
		[_buttons release];
		_buttons = [[NSMutableArray alloc] init];
		
		for (NSArray *page in _pages) {
			NSMutableArray *buttonPage = [NSMutableArray array];
			[_buttons addObject:buttonPage];
			
			for (UXLauncherItem *item in page) {
				UXLauncherButton *button = [self addButtonWithItem:item];
				[buttonPage addObject:button];
			}
		}
		
		[self layoutButtons];
	}

	-(void) checkButtonOverflow:(NSInteger)pageIndex {
		
		NSMutableArray *buttonPage	= [_buttons objectAtIndex:pageIndex];
		NSInteger maxButtonsPerPage = self.columnCount * self.rowCount;
		
		if (buttonPage.count > maxButtonsPerPage) {
			
			BOOL isLastPage					= pageIndex == _buttons.count - 1;
			
			NSMutableArray *itemsPage		= [_pages objectAtIndex:pageIndex];
			NSMutableArray *nextButtonPage	= nil;
			NSMutableArray *nextItemsPage	= nil;
			if (isLastPage) {
				nextButtonPage	= [NSMutableArray array];
				[_buttons addObject:nextButtonPage];
				nextItemsPage	= [NSMutableArray array];
				[_pages addObject:nextItemsPage];
			}
			else {
				nextButtonPage	= [_buttons objectAtIndex:pageIndex + 1];
				nextItemsPage	= [_pages objectAtIndex:pageIndex + 1];
			}
			
			while (buttonPage.count > maxButtonsPerPage) {
				[nextButtonPage insertObject:[buttonPage lastObject] atIndex:0];
				[buttonPage removeLastObject];
				[nextItemsPage insertObject:[itemsPage lastObject] atIndex:0];
				[itemsPage removeLastObject];
			}
			
			if (pageIndex + 1 < _buttons.count) {
				[self checkButtonOverflow:pageIndex + 1];
			}
		}
	}

	-(void) startDraggingButton:(UXLauncherButton *)button withEvent:(UIEvent *)event {
		UX_INVALIDATE_TIMER(_springLoadTimer);
		
		if (button) {
			button.transform = CGAffineTransformIdentity;
			[self addSubview:button];
			button.origin = [_scrollView convertPoint:button.origin toView:self];
			[button layoutIfNeeded];
		}
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:UX_FAST_TRANSITION_DURATION];
		
		if (_dragButton) {
			_dragButton.selected	= NO;
			_dragButton.highlighted = NO;
			_dragButton.dragging	= NO;
			[self layoutButtons];
		}
		
		if (button) {
			_dragButton					= button;
			NSIndexPath *indexPath		= [self indexPathOfItem:button.item];
			_positionOrigin				= [indexPath indexAtPosition:1];
			
			UITouch *touch				= [[event allTouches] anyObject];
			_touchOrigin				= [touch locationInView:_scrollView];
			_dragOrigin					= button.center;
			_dragTouch					= touch;
			button.dragging				= YES;
			_scrollView.scrollEnabled	= NO;
		}
		else {
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(releaseButtonDidStop)];
			_scrollView.scrollEnabled = YES;
		}
		
		[UIView commitAnimations];
	}

	-(void) removeButtonAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
		UXLauncherButton *button = context;
		[button removeFromSuperview];
	}

	-(void) springLoadTimer:(NSTimer *)timer {
		_springLoadTimer = nil;
		if ([(NSNumber *)timer.userInfo boolValue]) {
			CGFloat newX		= _scrollView.contentOffset.x - _scrollView.width;
			if (newX >= 0) {
				CGPoint offset	= CGPointMake(newX, 0);
				[_scrollView setContentOffset:offset animated:YES];
				[self updatePagerWithContentOffset:offset];
				_dragOrigin.x	+= _scrollView.width;
				_positionOrigin = -1;
				_springing		= YES;
				[self performSelector:@selector(springingDidStop) withObject:nil afterDelay:0.3];
			}
		}
		else {
			CGFloat newX		= _scrollView.contentOffset.x + _scrollView.width;
			if (newX <= _scrollView.contentSize.width - _scrollView.width) {
				CGPoint offset	= CGPointMake(newX, 0);
				[_scrollView setContentOffset:offset animated:YES];
				[self updatePagerWithContentOffset:offset];
				_dragOrigin.x	-= _scrollView.width;
				_positionOrigin = -1;
				_springing		= YES;
				[self performSelector:@selector(springingDidStop) withObject:nil afterDelay:0.3];
			}
		}
	}

	-(void) springingDidStop {
		_springing = NO;
	}

	-(void) releaseButtonDidStop {
		[_scrollView addSubview:_dragButton];
		_dragButton.origin	= [self convertPoint:_dragButton.origin toView:_scrollView];
		_dragButton			= nil;
	}

	-(void) buttonTouchedUpInside:(UXLauncherButton *)button {
		if (_editing) {
			if (button == _dragButton) {
				[self startDraggingButton:nil withEvent:nil];
			}
		}
		else {
			UX_INVALIDATE_TIMER(_editHoldTimer);
			[button setSelected:YES];
			[self performSelector:@selector(deselectButton:) withObject:button afterDelay:UX_TRANSITION_DURATION];
			NSString *URL = button.item.URL;
			if (URL) {
				if ([_delegate respondsToSelector:@selector(launcherView:didSelectItem:)]) {
					[_delegate launcherView:self didSelectItem:button.item];
				}
			}
		}
	}

	-(void) buttonTouchedUpOutside:(UXLauncherButton *)button {
		if (_editing) {
			if (button == _dragButton) {
				[self startDraggingButton:nil withEvent:nil];
			}
		}
		else {
			UX_INVALIDATE_TIMER(_editHoldTimer);
		}
	}

	-(void) buttonTouchedDown:(UXLauncherButton *)button withEvent:(UIEvent *)event {
		if (_editing) {
			if (!_dragButton) {
				[self startDraggingButton:button withEvent:event];
			}
		}
		else {
			UX_INVALIDATE_TIMER(_editHoldTimer);
			
			_editHoldTimer = [NSTimer scheduledTimerWithTimeInterval:kEditHoldTimeInterval
															  target:self selector:@selector(editHoldTimer:)
															userInfo:[UXUserInfo topic:nil strong:event weak:button]
															 repeats:NO];
		}
	}

	-(void) closeButtonTouchedUpInside:(UXButton *)closeButton {
		for (NSArray *buttonPage in _buttons) {
			for (UXLauncherButton *button in buttonPage) {
				if (button.closeButton == closeButton) {
					[self removeItem:button.item animated:YES];
					return;
				}
			}
		}
	}

	-(void) wobble {
		static BOOL wobblesLeft = NO;
		
		if (_editing) {
			CGFloat rotation = (kWobbleRadians * M_PI) / 180.0;
			CGAffineTransform wobbleLeft	= CGAffineTransformMakeRotation(rotation);
			CGAffineTransform wobbleRight	= CGAffineTransformMakeRotation(-rotation);
			
			[UIView beginAnimations:nil context:nil];
			
			NSInteger i = 0;
			NSInteger nWobblyButtons = 0;
			for (NSArray *buttonPage in _buttons) {
				for (UXLauncherButton *button in buttonPage) {
					if (button != _dragButton) {
						++nWobblyButtons;
						if (i % 2) {
							button.transform = wobblesLeft ? wobbleRight : wobbleLeft;
						}
						else {
							button.transform = wobblesLeft ? wobbleLeft : wobbleRight;
						}
					}
					++i;
				}
			}
			
			if (nWobblyButtons >= 1) {
				[UIView setAnimationDuration:kWobbleTime];
				[UIView setAnimationDelegate:self];
				[UIView setAnimationDidStopSelector:@selector(wobble)];
				wobblesLeft = !wobblesLeft;
			}
			else {
				[NSObject cancelPreviousPerformRequestsWithTarget:self];
				[self performSelector:@selector(wobble) withObject:nil afterDelay:kWobbleTime];
			}
			[UIView commitAnimations];
		}
	}

	/*-(void) wobble {
		static BOOL wobblesLeft = NO;
		
		if (_editing) {
			CGFloat rotation				= (kWobbleRadians * M_PI) / 180.0;
			CGAffineTransform wobbleLeft	= CGAffineTransformMakeRotation(rotation);
			CGAffineTransform wobbleRight	= CGAffineTransformMakeRotation(-rotation);
			
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.07];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(wobble)];
			
			NSInteger i = 0;
			for (NSArray *buttonPage in _buttons) {
				for (UXLauncherButton *button in buttonPage) {
					if (button != _dragButton) {
						if (i % 2) {
							button.transform = wobblesLeft ? wobbleRight : wobbleLeft;
						}
						else {
							button.transform = wobblesLeft ? wobbleLeft : wobbleRight;
						}
					}
					++i;
				}
			}
			
			[UIView commitAnimations];
			wobblesLeft = !wobblesLeft;
		}
	}*/

	-(void) editHoldTimer:(NSTimer *)timer {
		_editHoldTimer = nil;
		[self beginEditing];
		
		UXUserInfo *info			= timer.userInfo;
		UXLauncherButton *button	= info.weak;
		UIEvent *event				= info.strong;
		
		button.selected				= NO;
		button.highlighted			= NO;
		[self startDraggingButton:button withEvent:event];
	}

	-(void) deselectButton:(UXLauncherButton *)button {
		[button setSelected:NO];
	}

	-(void) endEditingAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
		for (NSArray *buttonPage in _buttons) {
			for (UXLauncherButton *button in buttonPage) {
				button.editing = NO;
			}
		}
	}

	-(void) updateTouch {
		
		CGPoint origin		= [_dragTouch locationInView:_scrollView];
		_dragButton.center	= CGPointMake(_dragOrigin.x + (origin.x - _touchOrigin.x), _dragOrigin.y + (origin.y - _touchOrigin.y));
		CGFloat x			= origin.x - _scrollView.contentOffset.x;
		NSInteger column	= round(x / _dragButton.width);
		NSInteger row		= round(origin.y / _dragButton.height);
		NSInteger itemIndex = (row * self.columnCount) + column;
		NSInteger pageIndex = floor(_scrollView.contentOffset.x / _scrollView.width);
		
		if (itemIndex != _positionOrigin) {
			
			NSMutableArray *currentButtonPage = [_buttons objectAtIndex:pageIndex];
			if (itemIndex > currentButtonPage.count) {
				itemIndex = currentButtonPage.count;
			}
			
			if (itemIndex != _positionOrigin) {
				[[_dragButton retain] autorelease];
				
				NSMutableArray *itemPage	= [self pageWithItem:_dragButton.item];
				NSMutableArray *buttonPage	= [self pageWithButton:_dragButton];
				[itemPage removeObject:_dragButton.item];
				[buttonPage removeObject:_dragButton];
				
				if (itemIndex > currentButtonPage.count) {
					itemIndex = currentButtonPage.count;
				}
				
				BOOL didMove					= itemIndex != _positionOrigin;
				NSMutableArray *currentItemPage = [_pages objectAtIndex:pageIndex];
				[currentItemPage insertObject:_dragButton.item atIndex:itemIndex];
				[currentButtonPage insertObject:_dragButton atIndex:itemIndex];
				_positionOrigin					= itemIndex;
				
				[self checkButtonOverflow:pageIndex];
				if (didMove) {
					if ([_delegate respondsToSelector:@selector(launcherView:didMoveItem:)]) {
						[_delegate launcherView:self didMoveItem:_dragButton.item];
					}
					[UIView beginAnimations:nil context:nil];
					[UIView setAnimationDuration:UX_TRANSITION_DURATION];
					[self layoutButtons];
					[UIView commitAnimations];
				}
			}
		}
		
		CGFloat springLoadDistance	= _dragButton.width * kSpringLoadFraction;
		//UXLOG(@"%f < %f", springLoadDistance, _dragButton.center.x);
		BOOL goToPreviousPage		= _dragButton.center.x - springLoadDistance < 0;
		BOOL goToNextPage			= ((_scrollView.width - _dragButton.center.x) - springLoadDistance) < 0;
		if (goToPreviousPage || goToNextPage) {
			if (!_springLoadTimer) {
				_springLoadTimer = [NSTimer scheduledTimerWithTimeInterval:kSpringLoadTimeInterval
																	target:self 
																  selector:@selector(springLoadTimer:)
																  userInfo:[NSNumber numberWithBool:goToPreviousPage] 
																   repeats:NO];
			}
		}
		else {
			UX_INVALIDATE_TIMER(_springLoadTimer);
		}
	}


	#pragma mark NSObject

	-(id) initWithFrame:(CGRect)frame {
		if (self = [super initWithFrame:frame]) {
			_pages			= nil;
			_buttons		= nil;
			_prompt			= nil;
			_editHoldTimer	= nil;
			_springLoadTimer = nil;
			_dragButton		= nil;
			_columnCount	= 0;
			_rowCount		= 0;
			_dragTouch		= nil;
			_editing		= NO;
			_springing		= NO;
			
			_scrollView									= [[UXLauncherScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - kPagerHeight)];
			_scrollView.delegate						= self;
			_scrollView.scrollsToTop					= NO;
			_scrollView.showsVerticalScrollIndicator	= NO;
			_scrollView.showsHorizontalScrollIndicator	= NO;
			_scrollView.alwaysBounceHorizontal			= YES;
			_scrollView.pagingEnabled					= YES;
			_scrollView.autoresizingMask				= (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
			_scrollView.delaysContentTouches			= NO;
			_scrollView.multipleTouchEnabled			= NO;
			[self addSubview:_scrollView];
			
			_pager						= [[UXPageControl alloc] init];
			_pager.dotStyle				= @"launcherPageDot:";
			_pager.autoresizingMask		= UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
			[_pager addTarget:self action:@selector(pageChanged) forControlEvents:UIControlEventValueChanged];
			[self addSubview:_pager];
			
			self.autoresizesSubviews	= YES;
			self.columnCount			= kDefaultColumnCount;
		}
		return self;
	}

	-(void) dealloc {
		for (NSArray *page in _pages) {
			for (UXLauncherItem *item in page) {
				item.launcher = nil;
			}
		}
		
		_scrollView.delegate = nil;
		
		UX_INVALIDATE_TIMER(_editHoldTimer);
		UX_INVALIDATE_TIMER(_springLoadTimer);
		UX_SAFE_RELEASE(_pages);
		UX_SAFE_RELEASE(_buttons);
		UX_SAFE_RELEASE(_scrollView);
		UX_SAFE_RELEASE(_pager);
		[super dealloc];
	}

	
	#pragma mark UIResponder

	-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
		[super touchesMoved:touches withEvent:event];
		if (_dragButton && !_springing) {
			for (UITouch *touch in touches) {
				if (touch == _dragTouch) {
					[self updateTouch];
					break;
				}
			}
		}
	}

	-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
		[super touchesEnded:touches withEvent:event];
		
		if (_dragTouch) {
			for (UITouch *touch in touches) {
				if (touch == _dragTouch) {
					_dragTouch = nil;
					break;
				}
			}
		}
	}


	#pragma mark UIView

	-(void) layoutSubviews {
		[super layoutSubviews];
		_pager.frame = CGRectMake(0, _scrollView.height, self.width, kPagerHeight);
		if (!_buttons) {
			[self recreateButtons];
		}
	}

	
	#pragma mark UIScrollViewDelegate

	-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
		UX_INVALIDATE_TIMER(_editHoldTimer);
	}

	-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
		[self updatePagerWithContentOffset:_scrollView.contentOffset];
	}

	
	#pragma mark UIPageControlDelegate

	-(void) pageChanged {
		_scrollView.contentOffset = CGPointMake(_pager.currentPage * _scrollView.width, 0);
	}

	
	#pragma mark API

	-(NSArray *) pages {
		return _pages;
	}

	-(void) setPages:(NSArray *)pages {
		for (NSArray *page in _pages) {
			for (UXLauncherItem *item in page) {
				item.launcher = nil;
			}
		}
		
		[_pages release];
		_pages = [[NSMutableArray alloc] init];
		
		for (NSArray *page in pages) {
			NSMutableArray *pageCopy = [page mutableCopy];
			[_pages addObject:pageCopy];
			for (UXLauncherItem *item in pageCopy) {
				item.launcher = self;
			}
			[pageCopy release];
		}
		
		UX_SAFE_RELEASE(_buttons);
		[self setNeedsLayout];
	}

	-(void) setColumnCount:(NSInteger)columnCount {
		if (_columnCount != columnCount) {
			_columnCount	= columnCount;
			_rowCount		= 0;
			UX_SAFE_RELEASE(_buttons);
			[self setNeedsLayout];
		}
	}

	-(NSInteger) rowCount {
		if (!_rowCount) {
			_rowCount = floor(self.height / [self rowHeight]);
		}
		return _rowCount;
	}

	-(NSInteger) currentPageIndex {
		return floor(_scrollView.contentOffset.x / _scrollView.width);
	}

	-(void) setCurrentPageIndex:(NSInteger)pageIndex {
		_scrollView.contentOffset = CGPointMake(_scrollView.width * pageIndex, 0);
	}

	-(void) addItem:(UXLauncherItem *)item animated:(BOOL)animated {
		if (![self itemWithURL:item.URL]) {
			item.launcher = self;
			
			if (!_pages) {
				_pages = [[NSMutableArray arrayWithObject:[NSMutableArray arrayWithObject:item]] retain];
			}
			else {
				NSMutableArray *page = [self pageWithFreeSpace:self.currentPageIndex];
				[page addObject:item];
			}
			
			if ([_delegate respondsToSelector:@selector(launcherView:didAddItem:)]) {
				[_delegate launcherView:self didAddItem:item];
			}
			
			if (_buttons) {
				[self recreateButtons];
			}
			
			[self scrollToItem:item animated:animated];
		}
	}

	-(void) removeItem:(UXLauncherItem *)item animated:(BOOL)animated {
		NSMutableArray *itemPage = [self pageWithItem:item];
		if (itemPage) {
			UXLauncherButton *button	= [self buttonForItem:item];
			NSMutableArray *buttonPage	= [self pageWithButton:button];
			
			item.launcher = nil;
			[itemPage removeObject:button.item];
			
			if (buttonPage) {
				[buttonPage removeObject:button];
				
				if (animated) {
					[UIView beginAnimations:nil context:button];
					[UIView setAnimationDuration:UX_FAST_TRANSITION_DURATION];
					[UIView setAnimationDelegate:self];
					[UIView setAnimationDidStopSelector:@selector(removeButtonAnimationDidStop:finished:context:)];
					[self layoutButtons];
					button.transform	= CGAffineTransformMakeScale(0.01, 0.01);
					button.alpha		= 0;
					[UIView commitAnimations];
				}
				else {
					[button removeFromSuperview];
					[self layoutButtons];
				}
			}
			
			if ([_delegate respondsToSelector:@selector(launcherView:didRemoveItem:)]) {
				[_delegate launcherView:self didRemoveItem:item];
			}
		}
	}

	-(UXLauncherItem *) itemWithURL:(NSString *)URL {
		for (NSArray *page in _pages) {
			for (UXLauncherItem *item in page) {
				if ([item.URL isEqualToString:URL]) {
					return item;
				}
			}
		}
		return nil;
	}

	-(NSIndexPath *) indexPathOfItem:(UXLauncherItem *)item {
		for (NSUInteger pageIndex = 0; pageIndex < _pages.count; ++pageIndex) {
			NSArray *page			= [_pages objectAtIndex:pageIndex];
			NSUInteger itemIndex	= [page indexOfObject:item];
			if (itemIndex != NSNotFound) {
				NSUInteger path[] = {pageIndex, itemIndex};
				return [NSIndexPath indexPathWithIndexes:path length:2];
			}
		}
		return nil;
	}

	-(void) scrollToItem:(UXLauncherItem *)item animated:(BOOL)animated {
		NSIndexPath *path		= [self indexPathOfItem:item];
		if (path) {
			NSUInteger page		= [path indexAtPosition:0];
			CGFloat x			= page * _scrollView.width;
			[_scrollView setContentOffset:CGPointMake(x, 0) animated:animated];
		}
	}

	-(void) beginEditing {
		_editing							= YES;
		_scrollView.delaysContentTouches	= YES;
		UIView *prompt						= [self viewWithTag:kPromptTag];
		[prompt removeFromSuperview];
		
		for (NSArray *buttonPage in _buttons) {
			for (UXLauncherButton *button in buttonPage) {
				button.editing = YES;
				[button.closeButton addTarget:self action:@selector(closeButtonTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
			}
		}
		
		// Add a page at the end
		[_pages addObject:[NSMutableArray array]];
		[_buttons addObject:[NSMutableArray array]];
		[self updateContentSize:_pages.count];
		
		[self wobble];
		
		if ([_delegate respondsToSelector:@selector(launcherViewDidBeginEditing:)]) {
			[_delegate launcherViewDidBeginEditing:self];
		}
	}

	-(void) endEditing {
		_editing							= FALSE;
		_scrollView.delaysContentTouches	= FALSE;
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:UX_TRANSITION_DURATION];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(endEditingAnimationDidStop:finished:context:)];
		
		for (NSArray *buttonPage in _buttons) {
			for (UXLauncherButton *button in buttonPage) {
				button.transform			= CGAffineTransformIdentity;
				button.closeButton.alpha	= 0;
			}
		}
		
		[UIView commitAnimations];
		
		for (NSInteger i = 0; i < _pages.count; ++i) {
			NSArray *page = [_pages objectAtIndex:i];
			if (!page.count) {
				[_pages removeObjectAtIndex:i];
				[_buttons removeObjectAtIndex:i];
				--i;
			}
		}
		
		[self layoutButtons];
		if ([_delegate respondsToSelector:@selector(launcherViewDidEndEditing:)]) {
			[_delegate launcherViewDidEndEditing:self];
		}
	}

@end
