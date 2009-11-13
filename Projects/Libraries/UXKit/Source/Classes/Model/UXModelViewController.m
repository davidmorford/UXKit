
#import <UXKit/UXModelViewController.h>
#import <UXKit/UXNavigator.h>

@implementation UXModelViewController

	@synthesize model		= _model;
	@synthesize modelError	= _modelError;

	
	#pragma mark SPI

	-(void) resetViewStates {
		if (_flags.isShowingLoading) {
			[self showLoading:NO];
			_flags.isShowingLoading = NO;
		}
		if (_flags.isShowingModel) {
			[self showModel:NO];
			_flags.isShowingModel = NO;
		}
		if (_flags.isShowingError) {
			[self showError:NO];
			_flags.isShowingError = NO;
		}
		if (_flags.isShowingEmpty) {
			[self showEmpty:NO];
			_flags.isShowingEmpty = NO;
		}
	}

	-(void) updateViewStates {
		if (_flags.isModelDidRefreshInvalid) {
			[self didRefreshModel];
			_flags.isModelDidRefreshInvalid = NO;
		}
		if (_flags.isModelWillLoadInvalid) {
			[self willLoadModel];
			_flags.isModelWillLoadInvalid = NO;
		}
		if (_flags.isModelDidLoadInvalid) {
			[self didLoadModel:_flags.isModelDidLoadFirstTimeInvalid];
			_flags.isModelDidLoadInvalid = NO;
			_flags.isModelDidLoadFirstTimeInvalid = NO;
			_flags.isShowingModel = NO;
		}
		
		BOOL showModel	 = NO;
		BOOL showLoading = NO;
		BOOL showError	 = NO;
		BOOL showEmpty	 = NO;
		
		if (_model.isLoaded || ![self shouldLoad]) {
			if ([self canShowModel]) {
				showModel = !_flags.isShowingModel;
				_flags.isShowingModel = YES;
			}
			else {
				if (_flags.isShowingModel) {
					[self showModel:NO];
					_flags.isShowingModel = NO;
				}
			}
		}
		else {
			if (_flags.isShowingModel) {
				[self showModel:NO];
				_flags.isShowingModel = NO;
			}
		}
		
		if (_model.isLoading) {
			showLoading = !_flags.isShowingLoading;
			_flags.isShowingLoading = YES;
		}
		else {
			if (_flags.isShowingLoading) {
				[self showLoading:NO];
				_flags.isShowingLoading = NO;
			}
		}
		
		if (_modelError) {
			showError = !_flags.isShowingError;
			_flags.isShowingError = YES;
		}
		else {
			if (_flags.isShowingError) {
				[self showError:NO];
				_flags.isShowingError = NO;
			}
		}
		
		if (!_flags.isShowingLoading && !_flags.isShowingModel && !_flags.isShowingError) {
			showEmpty = !_flags.isShowingEmpty;
			_flags.isShowingEmpty = YES;
		}
		else {
			if (_flags.isShowingEmpty) {
				[self showEmpty:NO];
				_flags.isShowingEmpty = NO;
			}
		}
		
		if (showModel) {
			[self showModel:YES];
			[self didShowModel:_flags.isModelDidShowFirstTimeInvalid];
			_flags.isModelDidShowFirstTimeInvalid = NO;
		}
		if (showEmpty) {
			[self showEmpty:YES];
		}
		if (showError) {
			[self showError:YES];
		}
		if (showLoading) {
			[self showLoading:YES];
		}
	}

	-(void) createInterstitialModel {
		self.model = [[[UXModel alloc] init] autorelease];
	}


	#pragma mark <NSObject>

	-(id) init {
		if (self = [super init]) {
			_model			= nil;
			_modelError		= nil;
			_flags.isModelDidRefreshInvalid			= NO;
			_flags.isModelWillLoadInvalid			= NO;
			_flags.isModelDidLoadInvalid			= NO;
			_flags.isModelDidLoadFirstTimeInvalid	= NO;
			_flags.isModelDidShowFirstTimeInvalid	= NO;
			_flags.isViewInvalid	= YES;
			_flags.isViewSuspended	= NO;
			_flags.isUpdatingView	= NO;
			_flags.isShowingEmpty	= NO;
			_flags.isShowingLoading = NO;
			_flags.isShowingModel	= NO;
			_flags.isShowingError	= NO;
		}
		return self;
	}

	-(void) dealloc {
		[_model.delegates removeObject:self];
		UX_SAFE_RELEASE(_model);
		UX_SAFE_RELEASE(_modelError);
		[super dealloc];
	}

	
	#pragma mark @UIViewController

	-(void) viewWillAppear:(BOOL)animated {
		_isViewAppearing = YES;
		_hasViewAppeared = YES;
		[self updateView];
		[super viewWillAppear:animated];
	}

	-(void) didReceiveMemoryWarning {
		if (_hasViewAppeared && !_isViewAppearing) {
			[super didReceiveMemoryWarning];
			[self refresh];
		}
		else {
			[super didReceiveMemoryWarning];
		}
	}


	#pragma mark (UIXViewController)

	-(void) delayDidEnd {
		[self invalidateModel];
	}


	#pragma mark <UXModelDelegate>

	-(void) modelDidStartLoad:(id <UXModel>)aModel {
		if (aModel == self.model) {
			_flags.isModelWillLoadInvalid			= YES;
			_flags.isModelDidLoadFirstTimeInvalid	= YES;
			[self invalidateView];
		}
	}

	-(void) modelDidFinishLoad:(id <UXModel>)aModel {
		if (aModel == _model) {
			UX_SAFE_RELEASE(_modelError);
			_flags.isModelDidLoadInvalid = YES;
			[self invalidateView];
		}
	}

	-(void) model:(id <UXModel>)aModel didFailLoadWithError:(NSError *)error {
		if (aModel == _model) {
			self.modelError = error;
		}
	}

	-(void) modelDidCancelLoad:(id <UXModel>)aModel {
		if (aModel == _model) {
			[self invalidateView];
		}
	}

	-(void) modelDidChange:(id <UXModel>)aModel {
		if (aModel == _model) {
			[self refresh];
		}
	}

	-(void) model:(id <UXModel>)aModel didUpdateObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
	
	}

	-(void) model:(id <UXModel>)aModel didInsertObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
	
	}

	-(void) model:(id <UXModel>)aModel didDeleteObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
	
	}

	-(void) modelDidBeginUpdates:(id <UXModel>)model {
		if (model == _model) {
			[self beginUpdates];
		}
	}

	-(void) modelDidEndUpdates:(id <UXModel>)model {
		if (model == _model) {
			[self endUpdates];
		}
	}

	
	#pragma mark API

	-(id <UXModel>) model {
		if (!_model) {
			if (![UXNavigator navigator].isDelayed) {
				[self createModel];
			}
			if (!_model) {
				[self createInterstitialModel];
			}
		}
		return _model;
	}

	-(void) setModel:(id <UXModel>)model {
		if (_model != model) {
			[_model.delegates removeObject:self];
			[_model release];
			_model = [model retain];
			[_model.delegates addObject:self];
			UX_SAFE_RELEASE(_modelError);
			
			if (_model) {
				_flags.isModelWillLoadInvalid			= NO;
				_flags.isModelDidLoadInvalid			= NO;
				_flags.isModelDidLoadFirstTimeInvalid	= NO;
				_flags.isModelDidShowFirstTimeInvalid	= YES;
			}
			[self refresh];
		}
	}

	-(void) setModelError:(NSError *)error {
		if (error != _modelError) {
			[_modelError release];
			_modelError = [error retain];
			[self invalidateView];
		}
	}

	-(void) createModel {
	}

	-(void) invalidateModel {
		BOOL wasModelCreated = self.isModelCreated;
		[self resetViewStates];
		[_model.delegates removeObject:self];
		UX_SAFE_RELEASE(_model);
		if (wasModelCreated) {
			self.model;
		}
	}

	-(BOOL) isModelCreated {
		return !!_model;
	}

	-(BOOL) shouldLoad {
		return !self.model.isLoaded;
	}

	-(BOOL) shouldReload {
		//return !_modelError && self.model.isOutdated;
		//!!!: Fix inifinite Loop
		return !_modelError && !self.model.isLoading && self.model.isOutdated;
	}

	-(BOOL) shouldLoadMore {
		return NO;
	}

	-(BOOL) canShowModel {
		return YES;
	}

	-(void) reload {
		_flags.isViewInvalid = YES;
		[self.model load:UXURLRequestCachePolicyNetwork more:NO];
	}

	-(void) reloadIfNeeded {
		if ([self shouldReload] && !self.model.isLoading) {
			[self reload];
		}
	}

	-(void) refresh {
		_flags.isViewInvalid			= YES;
		_flags.isModelDidRefreshInvalid	= YES;
		
		BOOL loading	= self.model.isLoading;
		BOOL loaded		= self.model.isLoaded;
		if (!loading && !loaded && [self shouldLoad]) {
			[self.model load:UXURLRequestCachePolicyDefault more:NO];
		}
		else if (!loading && loaded && [self shouldReload]) {
			[self.model load:UXURLRequestCachePolicyNetwork more:NO];
		}
		else if (!loading && [self shouldLoadMore]) {
			[self.model load:UXURLRequestCachePolicyDefault more:YES];
		}
		else {
			_flags.isModelDidLoadInvalid = YES;
			if (_isViewAppearing) {
				[self updateView];
			}
		}
	}

	-(void) beginUpdates {
		_flags.isViewSuspended = YES;
	}

	-(void) endUpdates {
		_flags.isViewSuspended = NO;
		[self updateView];
	}

	-(void) invalidateView {
		_flags.isViewInvalid = YES;
		if (_isViewAppearing) {
			[self updateView];
		}
	}

	-(void) updateView {
		if (_flags.isViewInvalid && !_flags.isViewSuspended && !_flags.isUpdatingView) {
			_flags.isUpdatingView = YES;
			
			self.model;	// Ensure the model is created
			self.view;	// Ensure the view is created
			
			[self updateViewStates];
			if (_frozenState && _flags.isShowingModel) {
				[self restoreView:_frozenState];
				UX_SAFE_RELEASE(_frozenState);
			}
			_flags.isViewInvalid	= NO;
			_flags.isUpdatingView	= NO;
			[self reloadIfNeeded];
		}
	}

	-(void) didRefreshModel {
	
	}

	-(void) willLoadModel {
	
	}

	-(void) didLoadModel:(BOOL)firstTime {
	
	}

	-(void) didShowModel:(BOOL)firstTime {
	
	}

	-(void) showLoading:(BOOL)show {
	
	}

	-(void) showModel:(BOOL)show {
	
	}

	-(void) showEmpty:(BOOL)show {
	
	}

	-(void) showError:(BOOL)show {
	
	}

@end
