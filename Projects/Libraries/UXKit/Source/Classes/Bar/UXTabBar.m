
#import <UXKit/UXTabBar.h>
#import <UXKit/UXImageView.h>
#import <UXKit/UXLabel.h>
#import <UXKit/UXLayout.h>
#import <UXKit/UXDefaultStyleSheet.h>

static CGFloat			kTabMargin		= 10;
static CGFloat			kPadding		= 10;
static const NSInteger	kMaxBadgeNumber = 99;

@implementation UXTabBar

	@synthesize delegate		 = _delegate; 
	@synthesize tabItems		 = _tabItems; 
	@synthesize tabViews		 = _tabViews;
	@synthesize tabStyle		 = _tabStyle;
	@synthesize selectedTabIndex = _selectedTabIndex;

	#pragma mark SPI

	-(void) addTab:(UXTab *)aTab {
		[self addSubview:aTab];
	}

	-(CGSize) layoutTabs {
		CGFloat x = kTabMargin;

		if (self.contentMode == UIViewContentModeScaleToFill) {
			
			CGFloat maxTextWidth	= self.width - (kTabMargin * 2 + kPadding * 2 * _tabViews.count);
			CGFloat totalTextWidth	= 0;
			CGFloat totalTabWidth	= kTabMargin * 2;
			CGFloat maxTabWidth		= 0;
			
			for (int i = 0; i < _tabViews.count; ++i) {
				UXTab *tab = [_tabViews objectAtIndex:i];
				[tab sizeToFit];
				totalTextWidth	+= tab.width - kPadding * 2;
				totalTabWidth	+= tab.width;
				if (tab.width > maxTabWidth) {
					maxTabWidth = tab.width;
				}
			}

			if (totalTextWidth > maxTextWidth) {
				CGFloat shrinkFactor = maxTextWidth / totalTextWidth;
				for (int i = 0; i < _tabViews.count; ++i) {
					UXTab *tab			= [_tabViews objectAtIndex:i];
					CGFloat textWidth	= tab.width - kPadding * 2;
					tab.frame			= CGRectMake(x, 0, ceil(textWidth * shrinkFactor) + kPadding * 2 , self.height);
					x					+= tab.width;
				}
			}
			else {
				CGFloat averageTabWidth = ceil((self.width - kTabMargin * 2) / _tabViews.count);
				if ((maxTabWidth > averageTabWidth) && (self.width - totalTabWidth < kTabMargin) ) {
					for (int i = 0; i < _tabViews.count; ++i) {
						UXTab *tab		= [_tabViews objectAtIndex:i];
						tab.frame		= CGRectMake(x, 0, tab.width, self.height);
						x				+= tab.width;
					}
				}
				else {
					for (int i = 0; i < _tabViews.count; ++i) {
						UXTab *tab		= [_tabViews objectAtIndex:i];
						tab.frame		= CGRectMake(x, 0, averageTabWidth, self.height);
						x				+= tab.width;
					}
				}
			}
		}
		else {
			for (int i = 0; i < _tabViews.count; ++i) {
				UXTab *tab	= [_tabViews objectAtIndex:i];
				[tab sizeToFit];
				tab.frame		= CGRectMake(x, 0, tab.width, self.height);
				x				+= tab.width;
			}
		}
		return CGSizeMake(x, self.height);
	}

	-(void) tabTouchedUp:(UXTab *)tab {
		self.selectedTabView = tab;
	}


	#pragma mark NSObject

	-(id) initWithFrame:(CGRect)frame  {
		if (self = [super initWithFrame:frame]) {
			_selectedTabIndex	= NSIntegerMax;
			_tabItems			= nil;
			_tabViews			= [[NSMutableArray alloc] init];
			_tabStyle			= nil;
			self.style			= UXSTYLE(tabBar);
			self.tabStyle		= @"tab:";
		}
		return self;
	}


	#pragma mark UIView

	-(void) layoutSubviews {
		[super layoutSubviews];
		[self layoutTabs];
	}


	#pragma mark API

	-(UXTabItem *) selectedTabItem {
		if (_selectedTabIndex != NSIntegerMax) {
			return [_tabItems objectAtIndex:_selectedTabIndex];
		}
		return nil;
	}

	-(void) setSelectedTabItem:(UXTabItem *)tabItem {
		self.selectedTabIndex = [_tabItems indexOfObject:tabItem];
	}

	-(UXTab *) selectedTabView {
		if ((_selectedTabIndex != NSIntegerMax) && (_selectedTabIndex < _tabViews.count) ) {
			return [_tabViews objectAtIndex:_selectedTabIndex];
		}
		return nil;
	}

	-(void) setSelectedTabView:(UXTab *)tab {
		self.selectedTabIndex = [_tabViews indexOfObject:tab];
	}

	-(void) setSelectedTabIndex:(NSInteger)index {
		if (index != _selectedTabIndex) {
			if (_selectedTabIndex != NSIntegerMax) {
				self.selectedTabView.selected = NO;
			}

			_selectedTabIndex = index;

			if (_selectedTabIndex != NSIntegerMax) {
				self.selectedTabView.selected = YES;
			}

			if ([_delegate respondsToSelector:@selector(tabBar:tabSelected:)]) {
				[_delegate tabBar:self tabSelected:_selectedTabIndex];
			}
		}
	}

	-(void) setTabItems:(NSArray *)tabItems {
		[_tabItems release];
		_tabItems =  [tabItems retain];

		for (int i = 0; i < _tabViews.count; ++i) {
			UXTab *tab = [_tabViews objectAtIndex:i];
			[tab removeFromSuperview];
		}

		[_tabViews removeAllObjects];

		if (_selectedTabIndex >= _tabViews.count) {
			_selectedTabIndex = 0;
		}

		for (int i = 0; i < _tabItems.count; ++i) {
			UXTabItem *tabItem	= [_tabItems objectAtIndex:i];
			UXTab *tab			= [[[UXTab alloc] initWithItem:tabItem tabBar:self] autorelease];
			[tab setStylesWithSelector:self.tabStyle];
			[tab addTarget:self action:@selector(tabTouchedUp:) forControlEvents:UIControlEventTouchUpInside];
			[self addTab:tab];
			[_tabViews addObject:tab];
			if (i == _selectedTabIndex) {
				tab.selected = YES;
			}
		}
		[self setNeedsLayout];
	}

	-(void) showTabAtIndex:(NSInteger)tabIndex {
		UXTab *tab	= [_tabViews objectAtIndex:tabIndex];
		tab.hidden		= NO;
	}

	-(void) hideTabAtIndex:(NSInteger)tabIndex {
		UXTab *tab	= [_tabViews objectAtIndex:tabIndex];
		tab.hidden		= YES;
	}


	#pragma mark -

	-(void) dealloc {
		UX_SAFE_RELEASE(_tabStyle);
		UX_SAFE_RELEASE(_tabItems);
		UX_SAFE_RELEASE(_tabViews);
		[super dealloc];
	}

@end

#pragma mark -

@implementation UXTabStrip

	-(void) addTab:(UXTab *)aTab {
		[_scrollView addSubview:aTab];
	}

	-(void) updateOverflow {
		if (_scrollView.contentOffset.x < (_scrollView.contentSize.width - self.width)) {
			if (!_overflowRight) {
				_overflowRight							= [[UXView alloc] init];
				_overflowRight.style					= UXSTYLE(tabOverflowRight);
				_overflowRight.userInteractionEnabled	= NO;
				_overflowRight.backgroundColor			= [UIColor clearColor];
				[_overflowRight sizeToFit];
				[self addSubview:_overflowRight];
			}

			_overflowRight.left		= self.width - _overflowRight.width;
			_overflowRight.hidden	= NO;
		}
		else {
			_overflowRight.hidden	= YES;
		}
		if (_scrollView.contentOffset.x > 0) {
			if (!_overflowLeft) {
				_overflowLeft							= [[UXView alloc] init];
				_overflowLeft.style						= UXSTYLE(tabOverflowLeft);
				_overflowLeft.userInteractionEnabled	= NO;
				_overflowLeft.backgroundColor			= [UIColor clearColor];
				[_overflowLeft sizeToFit];
				[self addSubview:_overflowLeft];
			}
			_overflowLeft.hidden	= NO;
		}
		else {
			_overflowLeft.hidden	= YES;
		}
	}

	-(CGSize) layoutTabs {
		CGSize size					= [super layoutTabs];
		CGPoint contentOffset		= _scrollView.contentOffset;
		_scrollView.frame			= self.bounds;
		_scrollView.contentSize		= CGSizeMake(size.width + kTabMargin, self.height);
		_scrollView.contentOffset	= contentOffset;
		return size;
	}


	#pragma mark NSObject

	-(id) initWithFrame:(CGRect)frame  {
		if (self = [super initWithFrame:frame]) {
			_overflowLeft		= nil;
			_overflowRight		= nil;
			_scrollView			= [[UIScrollView alloc] init];
			_scrollView.scrollEnabled					= YES;
			_scrollView.scrollsToTop					= NO;
			_scrollView.showsVerticalScrollIndicator	= NO;
			_scrollView.showsHorizontalScrollIndicator	= NO;
			[self addSubview:_scrollView];

			self.style		= UXSTYLE(tabStrip);
			self.tabStyle	= @"tabRound:";
		}
		return self;
	}


	#pragma mark UIView

	-(void) layoutSubviews {
		[super layoutSubviews];
		[self updateOverflow];
	}


	#pragma mark UXTabBar

	-(void) setTabItems:(NSArray *)tabItems {
		[super setTabItems:tabItems];
		[self updateOverflow];
	}


	#pragma mark -

	-(void) dealloc {
		UX_SAFE_RELEASE(_overflowLeft);
		UX_SAFE_RELEASE(_overflowRight);
		UX_SAFE_RELEASE(_scrollView);
		[super dealloc];
	}

@end

#pragma mark -

@implementation UXTabGrid

	@synthesize columnCount = _columnCount;


	#pragma mark SPI

	-(NSInteger) rowCount {
		return ceil((float)self.tabViews.count / self.columnCount);
	}

	-(void) updateTabStyles {
		CGFloat columnCount		= [self columnCount];
		int rowCount			= [self rowCount];
		int cellCount			= rowCount * columnCount;
		if (self.tabViews.count > columnCount) {
			int column = 0;
			for (UXTab *tab in self.tabViews) {
				if (column == 0) {
					[tab setStylesWithSelector:@"tabGridTabTopLeft:"];
				}
				else if (column == columnCount - 1)  {
					[tab setStylesWithSelector:@"tabGridTabTopRight:"];
				}
				else if (column == cellCount - columnCount)  {
					[tab setStylesWithSelector:@"tabGridTabBottomLeft:"];
				}
				else if (column == cellCount - 1)  {
					[tab setStylesWithSelector:@"tabGridTabBottomRight:"];
				}
				else {
					[tab setStylesWithSelector:@"tabGridTabCenter:"];
				}
				++column;
			}
		}
		else {
			int column = 0;
			for (UXTab *tab in self.tabViews) {
				if (column == 0) {
					[tab setStylesWithSelector:@"tabGridTabLeft:"];
				}
				else if (column == columnCount - 1)  {
					[tab setStylesWithSelector:@"tabGridTabRight:"];
				}
				else {
					[tab setStylesWithSelector:@"tabGridTabCenter:"];
				}
				++column;
			}
		}
	}

	-(CGSize) layoutTabs {
		if (self.width && self.height) {
			UXGridLayout *layout	= [[[UXGridLayout alloc] init] autorelease];
			layout.padding			= 1;
			layout.columnCount		= [self columnCount];
			return [layout layoutSubviews:self.tabViews forView:self];
		}
		else {
			return self.frame.size;
		}
	}


	#pragma mark NSObject

	-(id) initWithFrame:(CGRect)frame  {
		if (self = [super initWithFrame:frame]) {
			self.style		= UXSTYLE(tabGrid);
			_columnCount	= 3;
		}
		return self;
	}


	#pragma mark UIView

	-(CGSize) sizeThatFits:(CGSize)size {
		CGSize styleSize = [super sizeThatFits:size];
		for (UXTab *tab in self.tabViews) {
			CGSize tabSize		= [tab sizeThatFits:CGSizeZero];
			NSInteger rowCount	= [self rowCount];
			return CGSizeMake(size.width, rowCount ? tabSize.height * [self rowCount] + styleSize.height : 0);
		}
		return size;
	}

	-(void) setTabItems:(NSArray *)tabItems {
		[super setTabItems:tabItems];
		[self updateTabStyles];
	}

@end

#pragma mark -

@implementation UXTab

	@synthesize tabItem = _tabItem;


	#pragma mark Initializer

	-(id) initWithItem:(UXTabItem *)tabItem tabBar:(UXTabBar *)tabBar {
		if (self = [self init]) {
			_badge			= nil;
			self.tabItem	= tabItem;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_tabItem);
		UX_SAFE_RELEASE(_badge);
		[super dealloc];
	}


	#pragma mark -

	-(void) updateBadgeNumber {
		if (_tabItem.badgeNumber) {
			if (!_badge) {
				_badge							= [[UXLabel alloc] init];
				_badge.style					= UXSTYLE(badge);
				_badge.backgroundColor			= [UIColor clearColor];
				_badge.userInteractionEnabled	= NO;
				[self addSubview:_badge];
			}
			if (_tabItem.badgeNumber <= kMaxBadgeNumber) {
				_badge.text		= [NSString stringWithFormat:@"%d", _tabItem.badgeNumber];
			}
			else {
				_badge.text		= [NSString stringWithFormat:@"%d+", kMaxBadgeNumber];
			}
			[_badge sizeToFit];

			_badge.frame	= CGRectMake(self.width - _badge.width - 1, 1, _badge.width, _badge.height);
			_badge.hidden	= NO;
		}
		else {
			_badge.hidden	= YES;
		}
	}


	#pragma mark UXTabItemDelegate

	-(void) tabItem:(UXTabItem *)item badgeNumberChangedTo:(int)value {
		[self updateBadgeNumber];
	}


	#pragma mark -

	-(void) setTabItem:(UXTabItem *)aTabItem {
		if (aTabItem != _tabItem) {
			[_tabItem performSelector:@selector(setTabBar:) withObject:nil];
			[_tabItem release];
			_tabItem = [aTabItem retain];
			[_tabItem performSelector:@selector(setTabBar:) withObject:self];

			[self setTitle:_tabItem.title forState:UIControlStateNormal];
			[self setImage:_tabItem.icon forState:UIControlStateNormal];
			[self setImage:_tabItem.selectedIcon forState:UIControlStateSelected];
			
			if (_tabItem.badgeNumber) {
				[self updateBadgeNumber];
			}
		}
	}

@end

#pragma mark -

@implementation UXTabItem

	@synthesize title			= _title;
	@synthesize icon			= _icon;
	@synthesize selectedIcon	= _selectedIcon;
	@synthesize object			= _object;
	@synthesize badgeNumber		= _badgeNumber;


	#pragma mark Initializer

	-(id) initWithTitle:(NSString *)aTitle {
		if (self = [self init]) {
			self.title = aTitle;
		}
		return self;
	}

	-(id) init {
		if (self = [super init]) {
			_title		= nil;
			_icon		= nil;
			_object		= nil;
			_badgeNumber = 0;
			_tabBar		= nil;
		}
		return self;
	}


	#pragma mark -

	-(void) setTabBar:(UXTabBar *)tabBar {
		_tabBar = tabBar;
	}


	#pragma mark -

	-(void) setBadgeNumber:(NSUInteger)value {
		value			= value < 0 ? 0 : value;
		_badgeNumber	= value;
		[_tabBar performSelector:@selector(tabItem:badgeNumberChangedTo:) withObject:self withObject:(id)value];
	}


	#pragma mark -

	-(void) dealloc {
		UX_SAFE_RELEASE(_title);
		UX_SAFE_RELEASE(_icon);
		UX_SAFE_RELEASE(_object);
		[super dealloc];
	}

@end

#pragma mark -

@implementation UXTabButtonBar

	-(CGSize) layoutTabs {
		CGFloat totalWidth	= self.width;
		CGFloat tabCount	= self.tabViews.count;
		CGFloat tabWidth	= totalWidth / tabCount;
		CGFloat tabHeight	= self.height;
		
		CGFloat x = 0;
		for (int i = 0; i < tabCount; i++) {
			UXTab *tab		= [self.tabViews objectAtIndex:i];
			tab.frame		= CGRectMake(x, 0, tabWidth, tabHeight);
			x				+= tabWidth;
		}
		return self.frame.size;
	}

	-(void) layoutSubviews {
		[super layoutSubviews];
		[self layoutTabs];
	}

@end
