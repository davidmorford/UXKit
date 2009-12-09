
#import <UXKit/UXPhotoView.h>
#import <UXKit/UXDefaultStyleSheet.h>
#import <UXKit/UXImageView.h>
#import <UXKit/UXLabel.h>
#import <UXKit/UXActivityLabel.h>
#import <UXKit/UXURLCache.h>
#import <UXKit/UXURLRequestQueue.h>

@implementation UXPhotoView

	@synthesize photo		 = _photo;
	@synthesize captionStyle = _captionStyle;
	@synthesize hidesExtras  = _hidesExtras; 
	@synthesize hidesCaption = _hidesCaption;

	#pragma mark API

	-(BOOL) loadVersion:(UXPhotoVersion)version fromNetwork:(BOOL)fromNetwork {
		NSString *URL = [_photo URLForVersion:version];
		if (URL) {
			UIImage *image		= [[UXURLCache sharedCache] imageForURL:URL];
			if (image || fromNetwork) {
				_photoVersion	= version;
				self.URL		= URL;
				return YES;
			}
		}
		return NO;
	}

	-(void) showCaption:(NSString *)caption {
		if (caption) {
			if (!_captionLabel) {
				_captionLabel			= [[UXLabel alloc] init];
				_captionLabel.opaque	= NO;
				_captionLabel.style		= _captionStyle ? _captionStyle : UXSTYLEWITHSELECTOR(photoCaption);
				_captionLabel.alpha		= _hidesCaption ? 0 : 1;
				[self addSubview:_captionLabel];
			}
		}
		_captionLabel.text = caption;
		[self setNeedsLayout];
	}


	#pragma mark <NSObject>

	-(id) initWithFrame:(CGRect)frame {
		if (self = [super initWithFrame:frame]) {
			_photo				= nil;
			_statusSpinner		= nil;
			_statusLabel		= nil;
			_captionStyle		= nil;
			_captionLabel		= nil;
			_photoVersion		= UXPhotoVersionNone;
			_hidesExtras		= NO;
			_hidesCaption		= NO;
			self.clipsToBounds	= NO;
		}
		return self;
	}

	-(void) dealloc {
		[super setDelegate:nil];
		//!!!: above or below?
		[[UXURLRequestQueue mainQueue] cancelRequestsWithDelegate:self];
		UX_SAFE_RELEASE(_photo);
		UX_SAFE_RELEASE(_captionLabel);
		UX_SAFE_RELEASE(_captionStyle);
		UX_SAFE_RELEASE(_statusSpinner);
		UX_SAFE_RELEASE(_statusLabel);
		[super dealloc];
	}


	#pragma mark UIImageView

	-(void) setImage:(UIImage *)image {
		if ((image != _defaultImage) || !_photo || (self.URL != [_photo URLForVersion:UXPhotoVersionLarge]) ) {
			if (image == _defaultImage) {
				self.contentMode = UIViewContentModeCenter;
			}
			else {
				self.contentMode = UIViewContentModeScaleAspectFill;
			}
			[super setImage:image];
		}
	}

	-(void) imageViewDidStartLoad {
		[self showProgress:0];
	}

	-(void) imageViewDidLoadImage:(UIImage *)image {
		if (!_photo.photoSource.isLoading) {
			[self showProgress:-1];
			[self showStatus:nil];
		}
		
		if (!_photo.size.width) {
			_photo.size = image.size;
			[self.superview setNeedsLayout];
		}
	}

	-(void) imageViewDidFailLoadWithError:(NSError *)error {
		[self showProgress:0];
		if (error) {
			[self showStatus:UXDescriptionForError(error)];
		}
	}


	#pragma mark UIView

	-(void) layoutSubviews {
		CGRect screenBounds	= UXScreenBounds();
		CGFloat width		= self.width;
		CGFloat height		= self.height;
		CGFloat cx			= self.bounds.origin.x + width / 2;
		CGFloat cy			= self.bounds.origin.y + height / 2;
		
		CGFloat marginRight		= 0; 
		CGFloat marginLeft		= 0;
		CGFloat marginBottom	= UXToolbarHeight();
		
		// Since the photo view is constrained to the size of the image, but we want to position
		// the status views relative to the screen, offset by the difference
		CGFloat screenOffset	= -floor(screenBounds.size.height / 2 - height / 2);
		
		// Vertically center in the space between the bottom of the image and the bottom of the screen
		CGFloat imageBottom		= screenBounds.size.height / 2 + self.defaultImage.size.height / 2;
		CGFloat textWidth		= screenBounds.size.width - (marginLeft + marginRight);

		// Giving the activity view a sensible location in the case that the default image fills the screen.

		if (imageBottom >= CGRectGetMaxY(screenBounds)) {
			imageBottom = CGRectGetMaxY(screenBounds) - CGRectGetHeight(screenBounds) / 4.0f;
		}
		
		if (_statusLabel.text.length) {
			CGSize statusSize	= [_statusLabel sizeThatFits:CGSizeMake(textWidth, 0)];
			_statusLabel.frame	= CGRectMake(marginLeft + (cx - screenBounds.size.width / 2),
											 cy + floor(screenBounds.size.height / 2 - (statusSize.height + marginBottom)),
											 textWidth, 
											 statusSize.height);
		}
		else {
			_statusLabel.frame	= CGRectZero;
		}
		
		if (_captionLabel.text.length) {
			CGSize captionSize	= [_captionLabel sizeThatFits:CGSizeMake(textWidth, 0)];
			_captionLabel.frame = CGRectMake(marginLeft + (cx - screenBounds.size.width / 2),
											 cy + floor(screenBounds.size.height / 2 - (captionSize.height + marginBottom)),
											 textWidth, 
											 captionSize.height);
		}
		else {
			_captionLabel.frame = CGRectZero;
		}
		
		CGFloat spinnerTop		= _captionLabel.height ? _captionLabel.top - floor(_statusSpinner.height + _statusSpinner.height / 2) : screenOffset + imageBottom + floor(_statusSpinner.height / 2);
		_statusSpinner.frame	= CGRectMake(self.bounds.origin.x + floor(self.bounds.size.width / 2 - _statusSpinner.width / 2),
											 spinnerTop, 
											 _statusSpinner.width, 
											 _statusSpinner.height);
	}


	#pragma mark API

	-(void) setPhoto:(id <UXPhoto>)aPhoto {
		if (!aPhoto || (aPhoto != _photo) ) {
			[_photo release];
			_photo			= [aPhoto retain];
			_photoVersion	= UXPhotoVersionNone;
			self.URL		= nil;
			[self showCaption:aPhoto.caption];
		}
		
		if (!_photo || _photo.photoSource.isLoading) {
			[self showProgress:0];
		}
		else {
			[self showStatus:nil];
		}
	}

	-(void) setHidesExtras:(BOOL)flag {
		if (!flag) {
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:UX_FAST_TRANSITION_DURATION];
		}
		_hidesExtras			= flag;
		_statusSpinner.alpha	= _hidesExtras ? 0 : 1;
		_statusLabel.alpha		= _hidesExtras ? 0 : 1;
		_captionLabel.alpha		= _hidesExtras || _hidesCaption ? 0 : 1;
		if (!flag) {
			[UIView commitAnimations];
		}
	}

	-(void) setHidesCaption:(BOOL)flag {
		_hidesCaption		= flag;
		_captionLabel.alpha = flag ? 0 : 1;
	}

	-(BOOL) loadPreview:(BOOL)fromNetwork {
		if (![self loadVersion:UXPhotoVersionLarge fromNetwork:NO]) {
			if (![self loadVersion:UXPhotoVersionSmall fromNetwork:NO]) {
				if (![self loadVersion:UXPhotoVersionThumbnail fromNetwork:fromNetwork]) {
					return NO;
				}
			}
		}
		return YES;
	}

	-(void) loadImage {
		if (_photo) {
			_photoVersion	= UXPhotoVersionLarge;
			self.URL		= [_photo URLForVersion:UXPhotoVersionLarge];
		}
	}

	-(void) showProgress:(CGFloat)progress {
		if (progress >= 0) {
			if (!_statusSpinner) {
				_statusSpinner		= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
				[self addSubview:_statusSpinner];
			}
			
			[_statusSpinner startAnimating];
			_statusSpinner.hidden	= NO;
			[self showStatus:nil];
			[self setNeedsLayout];
		}
		else {
			[_statusSpinner stopAnimating];
			_statusSpinner.hidden	= YES;
			_captionLabel.hidden	= !!_statusLabel.text.length;
		}
	}

	-(void) showStatus:(NSString *)text {
		if (text) {
			if (!_statusLabel) {
				_statusLabel		= [[UXLabel alloc] init];
				_statusLabel.style	= UXSTYLEWITHSELECTOR(photoStatusLabel);
				_statusLabel.opaque = NO;
				[self addSubview:_statusLabel];
			}
			_statusLabel.hidden		= NO;
			[self showProgress:-1];
			[self setNeedsLayout];
			_captionLabel.hidden	= YES;
		}
		else {
			_statusLabel.hidden		= YES;
			_captionLabel.hidden	= NO;
		}
		_statusLabel.text			= text;
	}

@end
