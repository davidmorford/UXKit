
#import <UXKit/UXThumbsViewController.h>
#import <UXKit/UXPhotoViewController.h>
#import <UXKit/UXURLRequest.h>
#import <UXKit/UXNavigator.h>
#import <UXKit/UXTableItem.h>
#import <UXKit/UXURLCache.h>
#import <UXKit/UXStyleSheet.h>

static CGFloat		kThumbnailRowHeight = 79;
static CGFloat		kThumbSize			= 75;
static CGFloat		kThumbSpacing		= 4;

@implementation UXThumbsDataSource

	@synthesize photoSource = _photoSource;
	@synthesize delegate	= _delegate;


	#pragma mark SPI

	-(BOOL) hasMoreToLoad {
		return _photoSource.maxPhotoIndex + 1 < _photoSource.numberOfPhotos;
	}

	-(NSInteger) columnCount {
		CGFloat width = UXScreenBounds().size.width;
		return round((width - kThumbSpacing * 2) / (kThumbSize + kThumbSpacing));
	}


	#pragma mark <NSObject>

	-(id) initWithPhotoSource:(id <UXPhotoSource>)photoSource delegate:(id <UXThumbsTableViewCellDelegate>)delegate {
		if (self = [super init]) {
			_photoSource	= [photoSource retain];
			_delegate		= delegate;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_photoSource);
		[super dealloc];
	}


	#pragma mark <UITableViewDataSource>

	-(NSInteger) tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection {
		NSInteger maxIndex		= _photoSource.maxPhotoIndex;
		NSInteger columnCount	= self.columnCount;
		if (maxIndex >= 0) {
			maxIndex		+= 1;
			NSInteger count = ceil((maxIndex / columnCount) + (maxIndex % columnCount ? 1 : 0));
			if (self.hasMoreToLoad) {
				return count + 1;
			}
			else {
				return count;
			}
		}
		else {
			return 0;
		}
	}


	#pragma mark <UXTableViewDataSource>

	-(id <UXModel>) model {
		return _photoSource;
	}


	#pragma mark -

	-(id) tableView:(UITableView *)tableView objectForRowAtIndexPath:(NSIndexPath *)indexPath {
		if ((indexPath.row == [tableView numberOfRowsInSection:0] - 1) && self.hasMoreToLoad) {
			NSString *text		= UXLocalizedString(@"Load More Photos...", @"");
			NSString *caption	= nil;
			if (_photoSource.numberOfPhotos == -1) {
				caption = [NSString stringWithFormat:UXLocalizedString(@"Showing %@ Photos", @""), UXFormatInteger(_photoSource.maxPhotoIndex + 1)];
			}
			else {
				caption = [NSString stringWithFormat:UXLocalizedString(@"Showing %@ of %@ Photos", @""), UXFormatInteger(_photoSource.maxPhotoIndex + 1), UXFormatInteger(_photoSource.numberOfPhotos)];
			}
			return [UXTableMoreButton itemWithText:text subtitle:caption];
		}
		else {
			NSInteger columnCount = self.columnCount;
			return [_photoSource photoAtIndex:indexPath.row * columnCount];
		}
	}

	-(Class) tableView:(UITableView *)tableView cellClassForObject:(id)object {
		if ([object conformsToProtocol:@protocol(UXPhoto)]) {
			return [UXThumbsTableViewCell class];
		}
		else {
			return [super tableView:tableView cellClassForObject:object];
		}
	}

	-(void) tableView:(UITableView *)tableView cell:(UITableViewCell *)cell willAppearAtIndexPath:(NSIndexPath *)indexPath {
		if ([cell isKindOfClass:[UXThumbsTableViewCell class]]) {
			UXThumbsTableViewCell *thumbsCell = (UXThumbsTableViewCell *)cell;
			thumbsCell.delegate		= _delegate;
			thumbsCell.columnCount	= self.columnCount;
		}
	}

	-(NSIndexPath *) tableView:(UITableView *)tableView willInsertObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
		return nil;
	}

	-(NSIndexPath *) tableView:(UITableView *)tableView willRemoveObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
		return nil;
	}


	#pragma mark -

	-(NSString *) titleForEmpty {
		return UXLocalizedString(@"No Photos", @"");
	}

	-(NSString *) subtitleForEmpty {
		return UXLocalizedString(@"This photo set contains no photos.", @"");
	}

	-(UIImage *) imageForError:(NSError *)anError {
		return UXIMAGE(@"bundle://UXKit.bundle/Images/Navigation/photoDefault.png");
	}

	-(NSString *) subtitleForError:(NSError *)anError {
		return UXLocalizedString(@"Unable to load this photo set.", @"");
	}

@end

#pragma mark -

@implementation UXThumbsViewController

	@synthesize delegate	= _delegate;
	@synthesize photoSource = _photoSource;

	
	#pragma mark SPI

	-(void) suspendLoadingThumbnails:(BOOL)suspended {
		if (_photoSource.maxPhotoIndex >= 0) {
			NSArray *cells = _tableView.visibleCells;
			for (int i = 0; i < cells.count; ++i) {
				UXThumbsTableViewCell *cell = [cells objectAtIndex:i];
				if ([cell isKindOfClass:[UXThumbsTableViewCell class]]) {
					[cell suspendLoading:suspended];
				}
			}
		}
	}

	-(void) updateTableLayout {
		self.tableView.contentInset				= UIEdgeInsetsMake(UXBarsHeight() + 4, 0, 0, 0);
		self.tableView.scrollIndicatorInsets	= UIEdgeInsetsMake(UXBarsHeight(), 0, 0, 0);
	}

	-(NSString *) URLForPhoto:(id <UXPhoto>)photo {
		if ([photo respondsToSelector:@selector(URLValueWithName:)]) {
			return [photo URLValueWithName:@"UXPhotoViewController"];
		}
		else {
			return nil;
		}
	}

	
	#pragma mark Initializers

	-(id) initWithDelegate:(id <UXThumbsViewControllerDelegate>)delegate {
		if (self = [self init]) {
			self.delegate = delegate;
		}
		return self;
	}

	-(id) initWithQuery:(NSDictionary *)query {
		id <UXThumbsViewControllerDelegate> delegate = [query objectForKey:@"delegate"];
		if (delegate) {
			return [self initWithDelegate:delegate];
		}
		else {
			return [self init];
		}
	}


	#pragma mark <NSObject>
	
	-(id) init {
		if (self = [super init]) {
			_delegate						= nil;
			_photoSource					= nil;
			self.statusBarStyle				= UIStatusBarStyleBlackTranslucent;
			self.navigationBarStyle			= UIBarStyleBlackTranslucent;
			self.navigationBarTintColor		= nil;
			self.wantsFullScreenLayout		= YES;
			self.hidesBottomBarWhenPushed	= YES;
		}
		return self;
	}

	-(void) dealloc {
		[_photoSource.delegates removeObject:self];
		UX_SAFE_RELEASE(_photoSource);
		[super dealloc];
	}

	
	#pragma mark @UIViewController

	-(void) loadView {
		[super loadView];
		self.tableView.rowHeight			 = kThumbnailRowHeight;
		self.tableView.autoresizingMask		 = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		self.tableView.backgroundColor		 = UXSTYLESHEETPROPERTY(backgroundColor);
		self.tableView.separatorStyle		 = UITableViewCellSeparatorStyleNone;
		[self updateTableLayout];
	}

	-(void) viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];
		[self suspendLoadingThumbnails:NO];
	}

	-(void) viewDidDisappear:(BOOL)animated {
		[self suspendLoadingThumbnails:YES];
		[super viewDidDisappear:animated];
	}

	-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
		return UXIsSupportedOrientation(interfaceOrientation);
	}

	-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
		[self updateTableLayout];
		[self.tableView reloadData];
	}

	
	#pragma mark (UIXViewController)

	-(BOOL) persistView:(NSMutableDictionary *)state {
		NSString *delegate = [[UXNavigator navigator] pathForObject:_delegate];
		if (delegate) {
			[state setObject:delegate forKey:@"delegate"];
		}
		return [super persistView:state];
	}

	-(void) restoreView:(NSDictionary *)state {
		[super restoreView:state];
		NSString *delegate = [state objectForKey:@"delegate"];
		if (delegate) {
			self.delegate = [[UXNavigator navigator] objectForPath:delegate];
		}
	}

	-(void) setDelegate:(id <UXThumbsViewControllerDelegate>)delegate {
		_delegate = delegate;
		if (_delegate) {
			self.navigationItem.leftBarButtonItem	= [[[UIBarButtonItem alloc] initWithCustomView:[[[UIView alloc] init] autorelease]] autorelease];
			self.navigationItem.rightBarButtonItem	= [[[UIBarButtonItem alloc] initWithTitle:UXLocalizedString(@"Done", @"") 
																					    style:UIBarButtonItemStyleBordered 
																					   target:self 
																					   action:@selector(removeFromSupercontroller)] autorelease];
		}
	}

	
	#pragma mark @UXModelViewController

	-(void) didRefreshModel {
		[super didRefreshModel];
		self.title = _photoSource.title;
	}


	#pragma mark @UXTableViewController

	-(CGRect) rectForOverlayView {
		return UXRectContract(CGRectOffset([super rectForOverlayView], 0, UXBarsHeight() - _tableView.top), 0, UXBarsHeight());
	}

	
	#pragma mark <UXThumbsTableViewCellDelegate>

	-(void) thumbsTableViewCell:(UXThumbsTableViewCell *)cell didSelectPhoto:(id <UXPhoto>)photo {
		[_delegate thumbsViewController:self didSelectPhoto:photo];
		
		BOOL shouldNavigate = YES;
		if ([_delegate respondsToSelector:@selector(thumbsViewController:shouldNavigateToPhoto:)]) {
			shouldNavigate = [_delegate thumbsViewController:self shouldNavigateToPhoto:photo];
		}
		
		if (shouldNavigate) {
			NSString *URL = [self URLForPhoto:photo];
			if (URL) {
				UXOpenURL(URL);
			}
			else {
				UXPhotoViewController *controller = [self createPhotoViewController];
				controller.centerPhoto = photo;
				[self.navigationController pushViewController:controller animated:YES];
			}
		}
	}

	
	#pragma mark API

	-(void) setPhotoSource:(id <UXPhotoSource>)photoSource {
		if (photoSource != _photoSource) {
			[_photoSource release];
			_photoSource	= [photoSource retain];
			self.title		= _photoSource.title;
			self.dataSource = [self createDataSource];
		}
	}

	-(UXPhotoViewController *) createPhotoViewController {
		return [[[UXPhotoViewController alloc] init] autorelease];
	}

	-(id <UXTableViewDataSource>) createDataSource {
		return [[[UXThumbsDataSource alloc] initWithPhotoSource:_photoSource delegate:self] autorelease];
	}

@end
