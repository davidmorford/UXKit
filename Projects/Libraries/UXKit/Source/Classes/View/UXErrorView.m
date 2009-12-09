
#import <UXKit/UXErrorView.h>
#import <UXKit/UXDefaultStyleSheet.h>

static CGFloat kVPadding1	= 30;
static CGFloat kVPadding2	= 20;
static CGFloat kHPadding	= 10;

@implementation UXErrorView

	#pragma mark Initializers

	-(id)  initWithTitle:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)image {
		if (self = [self init]) {
			self.title		= title;
			self.subtitle	= subtitle;
			self.image		= image;
		}
		return self;
	}

	-(id) initWithFrame:(CGRect)frame {
		if (self = [super initWithFrame:frame]) {
			_imageView						= [[UIImageView alloc] init];
			_imageView.contentMode			= UIViewContentModeCenter;
			[self addSubview:_imageView];
			
			_titleView						= [[UILabel alloc] init];
			_titleView.backgroundColor		= [UIColor clearColor];
			_titleView.textColor			= UXSTYLESHEETPROPERTY(tableErrorTextColor);
			_titleView.font					= UXSTYLESHEETPROPERTY(errorTitleFont);
			_titleView.textAlignment		= UITextAlignmentCenter;
			[self addSubview:_titleView];
			
			_subtitleView					= [[UILabel alloc] init];
			_subtitleView.backgroundColor	= [UIColor clearColor];
			_subtitleView.textColor			= UXSTYLESHEETPROPERTY(tableErrorTextColor);
			_subtitleView.font				= UXSTYLESHEETPROPERTY(errorSubtitleFont);
			_subtitleView.textAlignment		= UITextAlignmentCenter;
			_subtitleView.numberOfLines		= 0;
			[self addSubview:_subtitleView];
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_imageView);
		UX_SAFE_RELEASE(_titleView);
		UX_SAFE_RELEASE(_subtitleView);
		[super dealloc];
	}

	#pragma mark UIView

	-(void) layoutSubviews {
		_subtitleView.size = [_subtitleView sizeThatFits:CGSizeMake(self.width - kHPadding * 2, 0)];
		[_titleView sizeToFit];
		[_imageView sizeToFit];
		
		CGFloat maxHeight = _imageView.height + _titleView.height + _subtitleView.height + kVPadding1 + kVPadding2;
		/*BOOL canShowImage = _imageView.image && self.height > maxHeight;*/
		BOOL canShowImage = _imageView.image && self.height < maxHeight;
		 
		CGFloat totalHeight = 0;
		
		if (canShowImage) {
			totalHeight += _imageView.height;
		}
		if (_titleView.text.length) {
			totalHeight += (totalHeight ? kVPadding1 : 0) + _titleView.height;
		}
		if (_subtitleView.text.length) {
			totalHeight += (totalHeight ? kVPadding2 : 0) + _subtitleView.height;
		}
		
		//CGFloat top = floor(self.height / 2 - totalHeight / 2);
		CGFloat top = 261.0f;
		if (canShowImage) {
			//_imageView.origin	= CGPointMake(floor(self.width / 2 - _imageView.width / 2), top);
			_imageView.hidden	= NO;
			//top					+= _imageView.height + kVPadding1;
		}
		else {
			_imageView.hidden = YES;
		}
		if (_titleView.text.length) {
			_titleView.origin = CGPointMake(floor(self.width / 2 - _titleView.width / 2), top);
			top += _titleView.height + kVPadding2;
		}
		if (_subtitleView.text.length) {
			_subtitleView.origin = CGPointMake(floor(self.width / 2 - _subtitleView.width / 2), top);
		}
	}


	#pragma mark -

	-(NSString *) title {
		return _titleView.text;
	}

	-(void) setTitle:(NSString *)aTitle {
		_titleView.text = aTitle;
	}

	-(NSString *) subtitle {
		return _subtitleView.text;
	}

	-(void) setSubtitle:(NSString *)aSubtitle {
		_subtitleView.text = aSubtitle;
	}

	-(UIImage *) image {
		return _imageView.image;
	}

	-(void) setImage:(UIImage *)anImage {
		_imageView.image = anImage;
	}

@end
