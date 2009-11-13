
#import <UXKit/UXActivityLabel.h>
#import <UXKit/UXView.h>
#import <UXKit/UXDefaultStyleSheet.h>
#import <UXKit/UXButton.h>

static CGFloat kMargin			= 10;
static CGFloat kPadding			= 15;
static CGFloat kBannerPadding	= 8;
static CGFloat kSpacing			= 6;
static CGFloat kProgressMargin	= 6;

@implementation UXActivityLabel

	@synthesize style = _style;
	@synthesize progress = _progress;
	@synthesize smoothesProgress = _smoothesProgress;

	
	#pragma mark NSObject

	-(id) initWithFrame:(CGRect)frame style:(UXActivityLabelStyle)style text:(NSString *)text {
		if (self = [super initWithFrame:frame]) {
			_style				= style;
			_progress			= 0;
			_smoothesProgress	= NO;
			_smoothTimer		= nil;
			_progressView		= nil;
			
			_bezelView = [[UXView alloc] init];
			if (_style == UXActivityLabelStyleBlackBezel) {
				_bezelView.backgroundColor	= [UIColor clearColor];
				_bezelView.style			= UXSTYLE(blackBezel);
				self.backgroundColor		= [UIColor clearColor];
			}
			else if (_style == UXActivityLabelStyleWhiteBezel) {
				_bezelView.backgroundColor	= [UIColor clearColor];
				_bezelView.style			= UXSTYLE(whiteBezel);
				self.backgroundColor		= [UIColor clearColor];
			}
			else if (_style == UXActivityLabelStyleWhiteBox) {
				_bezelView.backgroundColor	= [UIColor clearColor];
				self.backgroundColor		= [UIColor whiteColor];
			}
			else if (_style == UXActivityLabelStyleBlackBox) {
				_bezelView.backgroundColor	= [UIColor clearColor];
				self.backgroundColor		= [UIColor colorWithWhite:0 alpha:0.8];
			}
			else if (_style == UXActivityLabelStyleBlackBanner) {
				_bezelView.backgroundColor	= [UIColor clearColor];
				_bezelView.style			= UXSTYLE(blackBanner);
				self.backgroundColor		= [UIColor clearColor];
			}
			else {
				_bezelView.backgroundColor	= [UIColor clearColor];
				self.backgroundColor		= [UIColor clearColor];
			}
			
			_label = [[UILabel alloc] init];
			_label.text = text;
			_label.backgroundColor = [UIColor clearColor];
			_label.lineBreakMode = UILineBreakModeTailTruncation;
			
			if (_style == UXActivityLabelStyleWhite) {
				_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
				_label.font = UXSTYLEVAR(activityLabelFont);
				_label.textColor = [UIColor whiteColor];
			}
			else if ((_style == UXActivityLabelStyleGray) || (_style == UXActivityLabelStyleWhiteBox) || (_style == UXActivityLabelStyleWhiteBezel) ) {
				_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
				_label.font = UXSTYLEVAR(activityLabelFont);
				_label.textColor = UXSTYLEVAR(tableActivityTextColor);
			}
			else if ((_style == UXActivityLabelStyleBlackBezel) || (_style == UXActivityLabelStyleBlackBox) ) {
				_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
				_activityIndicator.frame = CGRectMake(0, 0, 24, 24);
				_label.font = UXSTYLEVAR(activityLabelFont);
				_label.textColor = [UIColor whiteColor];
				_label.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
				_label.shadowOffset = CGSizeMake(1, 1);
			}
			else if (_style == UXActivityLabelStyleBlackBanner) {
				_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
				_label.font = UXSTYLEVAR(activityBannerFont);
				_label.textColor = [UIColor whiteColor];
				_label.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
				_label.shadowOffset = CGSizeMake(1, 1);
			}
			
			[self addSubview:_bezelView];
			[_bezelView addSubview:_activityIndicator];
			[_bezelView addSubview:_label];
			[_activityIndicator startAnimating];
		}
		return self;
	}

	-(id) initWithFrame:(CGRect)frame style:(UXActivityLabelStyle)style {
		return [self initWithFrame:frame style:style text:nil];
	}

	-(id) initWithStyle:(UXActivityLabelStyle)style {
		return [self initWithFrame:CGRectZero style:style text:nil];
	}

	-(id) initWithFrame:(CGRect)frame {
		return [self initWithFrame:frame style:UXActivityLabelStyleWhiteBox text:nil];
	}

	-(void) dealloc {
		UX_INVALIDATE_TIMER(_smoothTimer);
		UX_SAFE_RELEASE(_bezelView);
		UX_SAFE_RELEASE(_progressView);
		UX_SAFE_RELEASE(_activityIndicator);
		UX_SAFE_RELEASE(_label);
		[super dealloc];
	}


	#pragma mark UIView

	-(void) layoutSubviews {
		[super layoutSubviews];
		
		CGSize textSize = [_label.text sizeWithFont:_label.font];
		
		CGFloat indicatorSize = 0;
		[_activityIndicator sizeToFit];
		if (_activityIndicator.isAnimating) {
			if (_activityIndicator.height > textSize.height) {
				indicatorSize = textSize.height;
			}
			else {
				indicatorSize = _activityIndicator.height;
			}
		}
		
		CGFloat contentWidth = indicatorSize + kSpacing + textSize.width;
		CGFloat contentHeight = textSize.height > indicatorSize ? textSize.height : indicatorSize;
		
		if (_progressView) {
			[_progressView sizeToFit];
			contentHeight += _progressView.height + kSpacing;
		}
		
		CGFloat margin, padding, bezelWidth, bezelHeight;
		if ((_style == UXActivityLabelStyleBlackBezel) || (_style == UXActivityLabelStyleWhiteBezel) ) {
			margin = kMargin;
			padding = kPadding;
			bezelWidth = contentWidth + padding * 2;
			bezelHeight = contentHeight + padding * 2;
		}
		else {
			margin = 0;
			padding = kBannerPadding;
			bezelWidth = self.width;
			bezelHeight = self.height;
		}
		
		CGFloat maxBevelWidth = UXScreenBounds().size.width - margin * 2;
		if (bezelWidth > maxBevelWidth) {
			bezelWidth = maxBevelWidth;
			contentWidth = bezelWidth - (kSpacing + indicatorSize);
		}
		
		CGFloat textMaxWidth = (bezelWidth - (indicatorSize + kSpacing)) - padding * 2;
		CGFloat textWidth = textSize.width;
		if (textWidth > textMaxWidth) {
			textWidth = textMaxWidth;
		}
		
		_bezelView.frame = CGRectMake(floor(self.width / 2 - bezelWidth / 2),
									  floor(self.height / 2 - bezelHeight / 2),
									  bezelWidth, bezelHeight);
		
		CGFloat y = padding + floor((bezelHeight - padding * 2) / 2 - contentHeight / 2);
		
		if (_progressView) {
			if (_style == UXActivityLabelStyleBlackBanner) {
				y += kBannerPadding / 2;
			}
			_progressView.frame = CGRectMake(kProgressMargin, y,bezelWidth - kProgressMargin * 2, _progressView.height);
			y += _progressView.height + kSpacing - 1;
		}
		
		_label.frame = CGRectMake(floor((bezelWidth / 2 - contentWidth / 2) + indicatorSize + kSpacing), y, textWidth, textSize.height);
		
		_activityIndicator.frame = CGRectMake(_label.left - (indicatorSize + kSpacing), y, indicatorSize, indicatorSize);
	}

	-(CGSize) sizeThatFits:(CGSize)size {
		CGFloat padding;
		if ((_style == UXActivityLabelStyleBlackBezel) || (_style == UXActivityLabelStyleWhiteBezel) ) {
			padding = kPadding;
		}
		else {
			padding = kBannerPadding;
		}
		
		CGFloat height = _label.font.lineHeight + padding * 2;
		if (_progressView) {
			height += _progressView.height + kSpacing;
		}
		
		return CGSizeMake(size.width, height);
	}

	-(void) smoothTimer {
		if (_progressView.progress < _progress) {
			_progressView.progress += 0.01;
		}
		else {
			UX_INVALIDATE_TIMER(_smoothTimer);
		}
	}


	#pragma mark API

	-(NSString *) text {
		return _label.text;
	}

	-(void) setText:(NSString *)text {
		_label.text = text;
		[self setNeedsLayout];
	}

	-(UIFont *) font {
		return _label.font;
	}

	-(void) setFont:(UIFont *)font {
		_label.font = font;
		[self setNeedsLayout];
	}

	-(BOOL) isAnimating {
		return _activityIndicator.isAnimating;
	}

	-(void) setIsAnimating:(BOOL)isAnimating {
		if (isAnimating) {
			[_activityIndicator startAnimating];
		}
		else {
			[_activityIndicator stopAnimating];
		}
	}

	-(void) setProgress:(float)progress {
		_progress = progress;
		
		if (!_progressView) {
			_progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
			_progressView.progress = 0;
			[_bezelView addSubview:_progressView];
			[self setNeedsLayout];
		}
		
		if (_smoothesProgress) {
			if (!_smoothTimer) {
				_smoothTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 
																target:self
															  selector:@selector(smoothTimer) 
															  userInfo:nil 
															   repeats:YES];
			}
		}
		else {
			_progressView.progress = progress;
		}
	}

@end
