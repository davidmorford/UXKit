
#import <UXKit/UXPhotoViewController.h>
#import <UXKit/UXURLCache.h>
#import <UXKit/UXURLRequest.h>
#import <UXKit/UXPhotoView.h>
#import <UXKit/UXActivityLabel.h>
#import <UXKit/UXNavigator.h>

static const NSTimeInterval kPhotoLoadLongDelay		= 0.5;
static const NSTimeInterval kPhotoLoadShortDelay	= 0.25;
static const NSTimeInterval kSlideshowInterval		= 2;
static const NSInteger		kActivityLabelTag		= 96;

@interface UXPhotoViewController (Internal)
	-(void) moveToNextValidPhoto;
@end

#pragma mark -

@implementation UXPhotoViewController

	@synthesize photoSource			= _photoSource;
	@synthesize centerPhoto			= _centerPhoto;
	@synthesize	centerPhotoIndex	= _centerPhotoIndex;
	@synthesize defaultImage		= _defaultImage;
	@synthesize captionStyle		= _captionStyle;

	#pragma mark SPI

	-(UXPhotoView *) centerPhotoView {
		return (UXPhotoView *)_scrollView.centerPage;
	}

	-(void) loadImageDelayed {
		_loadTimer = nil;
		[self.centerPhotoView loadImage];
	}

	-(void) startImageLoadTimer:(NSTimeInterval)delay {
		[_loadTimer invalidate];
		_loadTimer = [NSTimer scheduledTimerWithTimeInterval:delay 
													  target:self
													selector:@selector(loadImageDelayed) 
													userInfo:nil 
													 repeats:NO];
	}

	-(void) cancelImageLoadTimer {
		[_loadTimer invalidate];
		_loadTimer = nil;
	}

	-(void) loadImages {
		UXPhotoView *centerPhotoView = self.centerPhotoView;
		for (UXPhotoView *photoView in _scrollView.visiblePages.objectEnumerator) {
			if (photoView == centerPhotoView) {
				[photoView loadPreview:NO];
			}
			else {
				[photoView loadPreview:YES];
			}
		}
		
		if (_delayLoad) {
			_delayLoad = NO;
			[self startImageLoadTimer:kPhotoLoadLongDelay];
		}
		else {
			[centerPhotoView loadImage];
		}
	}

	-(void) updateChrome {
		if (_photoSource.numberOfPhotos < 2) {
			self.title = _photoSource.title;
		}
		else {
			self.title = [NSString stringWithFormat:UXLocalizedString(@"%d of %d", @"Current page in photo browser (1 of 10)"), _centerPhotoIndex + 1, _photoSource.numberOfPhotos];
		}
		
		if (![self.previousViewController isKindOfClass:[UXThumbsViewController class]]) {
			if (_photoSource.numberOfPhotos > 1) {
				self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:UXLocalizedString(@"See All", @"See all photo thumbnails")
																						  style:UIBarButtonItemStyleBordered 
																						 target:self 
																						 action:@selector(showThumbnails)];
			}
			else {
				self.navigationItem.rightBarButtonItem = nil;
			}
		}
		else {
			self.navigationItem.rightBarButtonItem = nil;
		}
		
		UIBarButtonItem *playButton = [_toolbar itemWithTag:1];
		playButton.enabled			= _photoSource.numberOfPhotos > 1;
		_previousButton.enabled		= _centerPhotoIndex > 0;
		_nextButton.enabled			= _centerPhotoIndex >= 0 && _centerPhotoIndex < _photoSource.numberOfPhotos - 1;
		_deleteButton.enabled		= _photoSource.numberOfPhotos > 0;
	}

	-(void) updatePhotoView {
		_scrollView.centerPageIndex = _centerPhotoIndex;
		[self loadImages];
		[self updateChrome];
	}

	-(void) updateToolbarWithOrientation:(UIInterfaceOrientation)interfaceOrientation {
		if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
			_toolbar.height = UX_TOOLBAR_HEIGHT;
		}
		else {
			_toolbar.height = UX_LANDSCAPE_TOOLBAR_HEIGHT + 1;
		}
		_toolbar.top = self.view.height - _toolbar.height;
	}

	-(void) moveToPhoto:(id <UXPhoto>)photo {
		id <UXPhoto> previousPhoto	= [_centerPhoto autorelease];
		_centerPhoto					= [photo retain];
		[self didMoveToPhoto:_centerPhoto fromPhoto:previousPhoto];
	}

	-(void) moveToPhotoAtIndex:(NSInteger)photoIndex withDelay:(BOOL)withDelay {
		_centerPhotoIndex	= photoIndex == UX_NULL_PHOTO_INDEX ? 0 : photoIndex;
		[self moveToPhoto:[_photoSource photoAtIndex:_centerPhotoIndex]];
		_delayLoad			= withDelay;
	}

	-(void) showPhoto:(id <UXPhoto>)photo inView:(UXPhotoView *)photoView {
		photoView.photo = photo;
		if (!photoView.photo && _statusText) {
			[photoView showStatus:_statusText];
		}
	}

	-(void) updateVisiblePhotoViews {
		[self moveToPhoto:[_photoSource photoAtIndex:_centerPhotoIndex]];
		
		NSDictionary *photoViews = _scrollView.visiblePages;
		for (NSNumber *key in photoViews.keyEnumerator) {
			UXPhotoView *photoView	= [photoViews objectForKey:key];
			[photoView showProgress:-1];
			id <UXPhoto> photo		= [_photoSource photoAtIndex:key.intValue];
			[self showPhoto:photo inView:photoView];
		}
	}

	-(void) resetVisiblePhotoViews {
		NSDictionary *photoViews = _scrollView.visiblePages;
		for (UXPhotoView *photoView in photoViews.objectEnumerator) {
			if (!photoView.isLoading) {
				[photoView showProgress:-1];
			}
		}
	}

	-(BOOL) isShowingChrome {
		UINavigationBar *bar = self.navigationController.navigationBar;
		return bar ? bar.alpha != 0 : 1;
	}

	-(UXPhotoView *) statusView {
		if (!_photoStatusView) {
			_photoStatusView				= [[UXPhotoView alloc] initWithFrame:_scrollView.frame];
			_photoStatusView.defaultImage	= _defaultImage;
			_photoStatusView.photo			= nil;
			[_innerView addSubview:_photoStatusView];
		}
		return _photoStatusView;
	}

	-(void) showProgress:(CGFloat)progress {
		if ((self.hasViewAppeared || self.isViewAppearing) && (progress >= 0) && !self.centerPhotoView) {
			[self.statusView showProgress:progress];
			self.statusView.hidden = NO;
		}
		else {
			_photoStatusView.hidden = YES;
		}
	}

	-(void) showStatus:(NSString *)status {
		[_statusText release];
		_statusText = [status retain];
		if ((self.hasViewAppeared || self.isViewAppearing) && status && !self.centerPhotoView) {
			[self.statusView showStatus:status];
			self.statusView.hidden = NO;
		}
		else {
			_photoStatusView.hidden = YES;
		}
	}

	-(void) showCaptions:(BOOL)show {
		for (UXPhotoView *photoView in _scrollView.visiblePages.objectEnumerator) {
			photoView.hidesCaption = !show;
		}
	}

	-(NSString *) URLForThumbnails {
		if ([self.photoSource respondsToSelector:@selector(URLValueWithName:)]) {
			return [self.photoSource performSelector:@selector(URLValueWithName:) withObject:@"UXThumbsViewController"];
		}
		else {
			return nil;
		}
	}

	-(void) showThumbnails {
		NSString *URL = [self URLForThumbnails];
		if (!_thumbsController) {
			if (URL) {
				// The photo source has a URL mapping in UXURLMap, so we use that to show the thumbs
				NSDictionary *query = [NSDictionary dictionaryWithObject:self forKey:@"delegate"];
				_thumbsController = [[[UXNavigator navigator] viewControllerForURL:URL query:query] retain];
				[[UXNavigator navigator].URLMap setObject:_thumbsController forURL:URL];
			}
			else {
				// The photo source had no URL mapping in UXURLMap, so we let the subclass show the thumbs
				_thumbsController = [[self createThumbsViewController] retain];
				_thumbsController.photoSource = _photoSource;
			}
		}
		
		if (URL) {
			UXOpenURL(URL);
		}
		else {
			[self.navigationController pushViewController:_thumbsController animatedWithTransition:UIViewAnimationTransitionCurlDown];
		}
	}

	-(void) slideshowTimer {
		if (_centerPhotoIndex == _photoSource.numberOfPhotos - 1) {
			_scrollView.centerPageIndex = 0;
		}
		else {
			_scrollView.centerPageIndex = _centerPhotoIndex + 1;
		}
	}

	-(void) playAction {
		if (!_slideshowTimer) {
			UIBarButtonItem *pauseButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause 
																						  target:self 
																						  action:@selector(pauseAction)] autorelease];
			pauseButton.tag = 1;
			[_toolbar replaceItemWithTag:1 withItem:pauseButton];
			_slideshowTimer = [NSTimer scheduledTimerWithTimeInterval:kSlideshowInterval
															   target:self 
															 selector:@selector(slideshowTimer) 
															 userInfo:nil 
															  repeats:YES];
		}
	}

	-(void) pauseAction {
		if (_slideshowTimer) {
			UIBarButtonItem *playButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay 
																						 target:self 
																						 action:@selector(playAction)] autorelease];
			playButton.tag	= 1;
			[_toolbar replaceItemWithTag:1 withItem:playButton];
			[_slideshowTimer invalidate];
			_slideshowTimer = nil;
		}
	}

	-(void) nextAction {
		[self pauseAction];
		if (_centerPhotoIndex < _photoSource.numberOfPhotos - 1) {
			_scrollView.centerPageIndex = _centerPhotoIndex + 1;
		}
	}

	-(void) previousAction {
		[self pauseAction];
		if (_centerPhotoIndex > 0) {
			_scrollView.centerPageIndex = _centerPhotoIndex - 1;
		}
	}

	-(void) deleteFromSource {
		[_photoSource deletePhotoAtIndex:_centerPhotoIndex + 1];
		[self updateChrome];
	}

	-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
		if (!buttonIndex == [actionSheet cancelButtonIndex]) {
			[_photoSource deletePhotoAtIndex:_centerPhotoIndex];
			//[self previousAction];
			[self showActivity:nil];
			[self moveToNextValidPhoto];
			[_scrollView reloadData];
			[self refresh];
		}
	}

	-(void) deleteAction {
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to delete this photo?"
																 delegate:self
														cancelButtonTitle:@"Cancel"
												   destructiveButtonTitle:@"OK"
														otherButtonTitles:nil];
		[actionSheet showInView:self.view];
		[actionSheet release];
	}

	-(void) showBarsAnimationDidStop {
		self.navigationController.navigationBarHidden = NO;
	}

	-(void) hideBarsAnimationDidStop {
		self.navigationController.navigationBarHidden = YES;
	}

	
	#pragma mark <NSObject>


	-(id) initWithPhoto:(id <UXPhoto>)aPhoto {
		if (self = [self init]) {
			self.centerPhoto = aPhoto;
		}
		return self;
	}

	-(id) initWithPhotoSource:(id <UXPhotoSource>)aPhotoSource {
		if (self = [self init]) {
			self.photoSource = aPhotoSource;
		}
		return self;
	}

	-(id) init {
		if (self = [super init]) {
			_photoSource		= nil;
			_centerPhoto		= nil;
			_centerPhotoIndex	= 0;
			_scrollView			= nil;
			_photoStatusView	= nil;
			_toolbar			= nil;
			_defaultImage		= nil;
			_captionStyle		= nil;
			_nextButton			= nil;
			_previousButton		= nil;
			_deleteButton		= nil;
			_statusText			= nil;
			_thumbsController	= nil;
			_slideshowTimer		= nil;
			_loadTimer			= nil;
			_delayLoad			= NO;
			self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:UXLocalizedString(@"Photo", @"Title for back button that returns to photo browser")
																					  style:UIBarButtonItemStylePlain 
																					  target:nil 
																					  action:nil] autorelease];
			self.statusBarStyle				= UIStatusBarStyleBlackTranslucent;
			self.navigationBarStyle			= UIBarStyleBlackTranslucent;
			self.navigationBarTintColor		= nil;
			self.wantsFullScreenLayout		= YES;
			self.hidesBottomBarWhenPushed	= YES;
			self.defaultImage				= UXIMAGE(@"bundle://UXKit.bundle/Images/Navigation/photoDefault.png");
		}
		return self;
	}

	-(void) dealloc {
		_scrollView.delegate	= nil;
		_scrollView.dataSource	= nil;
		UX_SAFE_RELEASE(_scrollView);
		_thumbsController.delegate = nil;
		UX_SAFE_RELEASE(_photoStatusView);
		UX_SAFE_RELEASE(_deleteButton);
		UX_SAFE_RELEASE(_nextButton);
		UX_SAFE_RELEASE(_previousButton);
		UX_SAFE_RELEASE(_toolbar);
		UX_SAFE_RELEASE(_slideshowTimer);
		UX_SAFE_RELEASE(_loadTimer);
		UX_SAFE_RELEASE(_thumbsController);
		UX_SAFE_RELEASE(_centerPhoto);
		UX_SAFE_RELEASE(_photoSource);
		UX_SAFE_RELEASE(_statusText);
		UX_SAFE_RELEASE(_captionStyle);
		UX_SAFE_RELEASE(_defaultImage);
		UX_SAFE_RELEASE(_innerView);
		[super dealloc];
	}


	#pragma mark (UIXViewController)

	-(void) loadView {
		CGRect screenFrame	= [UIScreen mainScreen].bounds;
		self.view			= [[[UIView alloc] initWithFrame:screenFrame] autorelease];
		CGRect innerFrame	= CGRectMake(0, 0, screenFrame.size.width, screenFrame.size.height);
		
		_innerView = [[UIView alloc] initWithFrame:innerFrame];
		_innerView.autoresizingMask	= UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		
		[self.view addSubview:_innerView];
		
		_scrollView = [[UXScrollView alloc] initWithFrame:screenFrame];
		_scrollView.delegate			= self;
		_scrollView.dataSource			= self;
		_scrollView.backgroundColor		= [UIColor blackColor];
		_scrollView.autoresizingMask	= UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		[_innerView addSubview:_scrollView];
		
		_nextButton					= [[UIBarButtonItem alloc] initWithImage:UXIMAGE(@"bundle://UXKit.bundle/Images/Navigation/nextIcon.png") style:UIBarButtonItemStylePlain target:self action:@selector(nextAction)];
		_previousButton				= [[UIBarButtonItem alloc] initWithImage:UXIMAGE(@"bundle://UXKit.bundle/Images/Navigation/previousIcon.png") style:UIBarButtonItemStylePlain target:self action:@selector(previousAction)];
		_deleteButton				= [[UIBarButtonItem alloc] initWithImage:UXIMAGE(@"bundle://UXKit.bundle/Images/Navigation/deleteIcon.png") style:UIBarButtonItemStylePlain target:self action:@selector(deleteAction)];
		UIBarButtonItem *playButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playAction)] autorelease];
		playButton.tag				= 1;
		
		UIBarItem *space			= [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];		
		
		_toolbar					= [[UIToolbar alloc] initWithFrame:CGRectMake(0, screenFrame.size.height - UX_ROW_HEIGHT, screenFrame.size.width, UX_ROW_HEIGHT)];
		_toolbar.barStyle			= self.navigationBarStyle;
		_toolbar.autoresizingMask	= (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
		_toolbar.items				= [NSArray arrayWithObjects:space, _previousButton, space, _nextButton, space, _deleteButton, nil];
		[_innerView addSubview:_toolbar];
	}

	-(void) viewDidUnload {
		[super viewDidUnload];
		_scrollView.delegate	= nil;
		_scrollView.dataSource	= nil;
		UX_SAFE_RELEASE(_innerView);
		UX_SAFE_RELEASE(_scrollView);
		UX_SAFE_RELEASE(_photoStatusView);
		UX_SAFE_RELEASE(_deleteButton);
		UX_SAFE_RELEASE(_nextButton);
		UX_SAFE_RELEASE(_previousButton);
		UX_SAFE_RELEASE(_toolbar);
	}

	-(void) viewWillAppear:(BOOL)animated {
		[super viewWillAppear:animated];
		[self updateToolbarWithOrientation:self.interfaceOrientation];
	}

	-(void) viewWillDisappear:(BOOL)animated {
		[super viewWillDisappear:animated];
		[_scrollView cancelTouches];
		[self pauseAction];
		if (self.nextViewController) {
			[self showBars:YES animated:NO];
		}
	}

	-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
		return UXIsSupportedOrientation(interfaceOrientation);
	}

	-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
		[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
		[self updateToolbarWithOrientation:toInterfaceOrientation];
	}

	-(UIView *) rotatingFooterView {
		return _toolbar;
	}


	#pragma mark -

	-(void) showBars:(BOOL)show animated:(BOOL)animated {
		[super showBars:show animated:animated];
		
		CGFloat alpha = show ? 1 : 0;
		if (alpha == _toolbar.alpha) {
			return;
		}
		
		if (animated) {
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:UX_TRANSITION_DURATION];
			[UIView setAnimationDelegate:self];
			if (show) {
				[UIView setAnimationDidStopSelector:@selector(showBarsAnimationDidStop)];
			}
			else {
				[UIView setAnimationDidStopSelector:@selector(hideBarsAnimationDidStop)];
			}
		}
		else {
			if (show) {
				[self showBarsAnimationDidStop];
			}
			else {
				[self hideBarsAnimationDidStop];
			}
		}
		
		[self showCaptions:show];
		_toolbar.alpha = alpha;
		
		if (animated) {
			[UIView commitAnimations];
		}
	}

	-(void) showDetails {
		//UXOpenURL([NSString stringWithFormat:@"sportsbuy://contentItemDetailsViewer?item=%@", self.contentItem]);
	}


	#pragma mark @UXModelViewController

	-(BOOL) shouldLoad {
		return NO;
	}

	-(BOOL) shouldLoadMore {
		return !_centerPhoto;
	}

	-(BOOL) canShowModel {
		return _photoSource.numberOfPhotos > 0;
	}

	-(void) didRefreshModel {
		[super didRefreshModel];
		[self updatePhotoView];
	}

	-(void) didLoadModel:(BOOL)firstTime {
		[super didLoadModel:firstTime];
		if (firstTime) {
			[self updatePhotoView];
		}
	}

	-(void) showLoading:(BOOL)show {
		[self showProgress:show ? 0 : -1];
	}

	-(void) showEmpty:(BOOL)show {
		if (show) {
			[_scrollView reloadData];
			[self showStatus:UXLocalizedString(@"This photo set contains no photos.", @"")];
		}
		else {
			[self showStatus:nil];
		}
	}

	-(void) showError:(BOOL)show {
		if (show) {
			[self showStatus:UXDescriptionForError(_modelError)];
		}
		else {
			[self showStatus:nil];
		}
	}

	-(void) moveToNextValidPhoto {
		if (_centerPhotoIndex >= _photoSource.numberOfPhotos) {
			// We were positioned at an index that is past the end, so move to the last photo
			[self moveToPhotoAtIndex:_photoSource.numberOfPhotos - 1 withDelay:NO];
		}
		else {
			[self moveToPhotoAtIndex:_centerPhotoIndex withDelay:NO];
		}
	}


	#pragma mark <UXModelDelegate>

	-(void) modelDidFinishLoad:(id <UXModel>)aModel {
		if (aModel == _model) {
			if (_centerPhotoIndex >= _photoSource.numberOfPhotos) {
				[self moveToNextValidPhoto];
				[_scrollView reloadData];
				[self resetVisiblePhotoViews];
			}
			else {
				[self updateVisiblePhotoViews];
			}
		}
		[super modelDidFinishLoad:aModel];
	}

	-(void) model:(id <UXModel>)aModel didFailLoadWithError:(NSError *)anError {
		if (aModel == _model) {
			[self resetVisiblePhotoViews];
		}
		[super model:aModel didFailLoadWithError:anError];
	}

	-(void) modelDidCancelLoad:(id <UXModel>)aModel {
		if (aModel == _model) {
			[self resetVisiblePhotoViews];
		}
		[super modelDidCancelLoad:aModel];
	}

	-(void) model:(id <UXModel>)aModel didUpdateObject:(id)anObject atIndexPath:(NSIndexPath *)anIndexPath {
	
	}

	-(void) model:(id <UXModel>)aModel didInsertObject:(id)anObject atIndexPath:(NSIndexPath *)anIndexPath {
	
	}

	-(void) model:(id <UXModel>)aModel didDeleteObject:(id)anObject atIndexPath:(NSIndexPath *)anIndexPath {
		if (anObject == self.centerPhoto) {
			[self showActivity:nil];
			[self moveToNextValidPhoto];
			[_scrollView reloadData];
			[self refresh];
		}
	}


	#pragma mark <UXScrollViewDelegate>

	-(void) scrollView:(UXScrollView *)scrollView didMoveToPageAtIndex:(NSInteger)pageIndex {
		if (pageIndex != _centerPhotoIndex) {
			[self moveToPhotoAtIndex:pageIndex withDelay:YES];
			[self refresh];
		}
	}

	-(void) scrollViewWillBeginDragging:(UXScrollView *)scrollView {
		[self cancelImageLoadTimer];
		[self showCaptions:NO];
		[self showBars:NO animated:YES];
	}

	-(void) scrollViewDidEndDecelerating:(UXScrollView *)scrollView {
		[self startImageLoadTimer:kPhotoLoadShortDelay];
	}

	-(void) scrollViewWillRotate:(UXScrollView *)scrollView toOrientation:(UIInterfaceOrientation)orientation {
		self.centerPhotoView.hidesExtras	= TRUE;
	}

	-(void) scrollViewDidRotate:(UXScrollView *)scrollView {
		self.centerPhotoView.hidesExtras	= FALSE;
	}

	-(BOOL) scrollViewShouldZoom:(UXScrollView *)scrollView {
		return self.centerPhotoView.image != self.centerPhotoView.defaultImage;
	}

	-(void) scrollViewDidBeginZooming:(UXScrollView *)scrollView {
		self.centerPhotoView.hidesExtras	= TRUE;
	}

	-(void) scrollViewDidEndZooming:(UXScrollView *)scrollView {
		self.centerPhotoView.hidesExtras	= FALSE;
	}

	-(void) scrollView:(UXScrollView *)scrollView tapped:(UITouch *)touch {
		if ([self isShowingChrome]) {
			[self showBars:NO animated:YES];
		}
		else {
			[self showBars:YES animated:NO];
		}
	}


	#pragma mark <UXScrollViewDataSource>

	-(NSInteger) numberOfPagesInScrollView:(UXScrollView *)aScrollView {
		return _photoSource.numberOfPhotos;
	}

	-(UIView *) scrollView:(UXScrollView *)aScrollView pageAtIndex:(NSInteger)aPageIndex {
		UXPhotoView *photoView = (UXPhotoView *)[_scrollView dequeueReusablePage];
		if (!photoView) {
			photoView				= [self createPhotoView];
			photoView.captionStyle	= _captionStyle;
			photoView.defaultImage	= _defaultImage;
			photoView.hidesCaption	= _toolbar.alpha == 0;
		}
		
		id <UXPhoto> photo = [_photoSource photoAtIndex:aPageIndex];
		[self showPhoto:photo inView:photoView];
		
		return photoView;
	}

	-(CGSize) scrollView:(UXScrollView *)aScrollView sizeOfPageAtIndex:(NSInteger)aPageIndex {
		id <UXPhoto> photo = [_photoSource photoAtIndex:aPageIndex];
		return photo ? photo.size : CGSizeZero;
	}


	#pragma mark <UXThumbsViewControllerDelegate>

	-(void) thumbsViewController:(UXThumbsViewController *)aController didSelectPhoto:(id <UXPhoto>)aPhoto {
		self.centerPhoto = aPhoto;
		[self.navigationController popViewControllerAnimatedWithTransition:UIViewAnimationTransitionCurlUp];
	}

	-(BOOL) thumbsViewController:(UXThumbsViewController *)controller shouldNavigateToPhoto:(id <UXPhoto>)photo {
		return NO;
	}


	#pragma mark API

	-(void) setPhotoSource:(id <UXPhotoSource>)aPhotoSource {
		if (_photoSource != aPhotoSource) {
			[_photoSource release];
			_photoSource	= [aPhotoSource retain];
			
			[self moveToPhotoAtIndex:0 withDelay:NO];
			self.model		= _photoSource;
		}
	}

	-(void) setCenterPhoto:(id <UXPhoto>)aPhoto {
		if (_centerPhoto != aPhoto) {
			if (aPhoto.photoSource != _photoSource) {
				[_photoSource release];
				_photoSource	= [aPhoto.photoSource retain];
				
				[self moveToPhotoAtIndex:aPhoto.index withDelay:NO];
				self.model		= _photoSource;
			}
			else {
				[self moveToPhotoAtIndex:aPhoto.index withDelay:NO];
				[self refresh];
			}
		}
	}

	-(UXPhotoView *) createPhotoView {
		return [[[UXPhotoView alloc] init] autorelease];
	}

	-(UXThumbsViewController *) createThumbsViewController {
		return [[[UXThumbsViewController alloc] initWithDelegate:self] autorelease];
	}

	-(void) didMoveToPhoto:(id <UXPhoto>)aPhoto fromPhoto:(id <UXPhoto>)fromPhoto {
	
	}

	-(void) showActivity:(NSString *)aTitle {
		if (aTitle) {
			//TODO: autorelease?
			UXActivityLabel *label	= [[UXActivityLabel alloc] initWithStyle:UXActivityLabelStyleBlackBezel];
			label.tag				= kActivityLabelTag;
			label.text				= aTitle;
			label.frame				= _scrollView.frame;
			[_innerView addSubview:label];
			[label release];
			_scrollView.scrollEnabled = NO;
		}
		else {
			UIView *label = [_innerView viewWithTag:kActivityLabelTag];
			if (label) {
				[label removeFromSuperview];
			}
			_scrollView.scrollEnabled = YES;
		}
	}

@end
