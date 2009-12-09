
#import <UXKit/UXPickerViewCell.h>
#import <UXKit/UXDefaultStyleSheet.h>

static CGFloat kPaddingX = 8;
static CGFloat kPaddingY = 3;
static CGFloat kMaxWidth = 250;

@implementation UXPickerViewCell

	@synthesize object		= _object;
	@synthesize selected	= _selected;

	#pragma mark Initializer

	-(id) initWithFrame:(CGRect)frame {
		if (self = [super initWithFrame:frame]) {
			_object			= nil;
			_selected		= NO;
			
			_labelView						= [[UILabel alloc] init];
			_labelView.backgroundColor		= [UIColor clearColor];
			_labelView.textColor			= UXSTYLESHEETPROPERTY(textColor);
			_labelView.highlightedTextColor = UXSTYLESHEETPROPERTY(highlightedTextColor);
			_labelView.lineBreakMode		= UILineBreakModeTailTruncation;
			
			[self addSubview:_labelView];
			self.backgroundColor = [UIColor clearColor];
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_object);
		UX_SAFE_RELEASE(_labelView);
		[super dealloc];
	}


	#pragma mark UIView

	-(void) layoutSubviews {
		_labelView.frame = CGRectMake(kPaddingX, kPaddingY, self.frame.size.width - kPaddingX * 2, self.frame.size.height - kPaddingY * 2);
	}

	-(CGSize) sizeThatFits:(CGSize)size {
		CGSize labelSize	= [_labelView.text sizeWithFont:_labelView.font];
		CGFloat width		= labelSize.width + kPaddingX * 2;
		return CGSizeMake(width > kMaxWidth ? kMaxWidth : width, labelSize.height + kPaddingY * 2);
	}

	-(UXStyle *) style {
		if (self.selected) {
			return UXSTYLEWITHSELECTORSTATE(pickerCell :, UIControlStateSelected);
		}
		else {
			return UXSTYLEWITHSELECTORSTATE(pickerCell :, UIControlStateNormal);
		}
	}


	#pragma mark API

	-(NSString *) label {
		return _labelView.text;
	}

	-(void) setLabel:(NSString *)label {
		_labelView.text = label;
	}

	-(UIFont *) font {
		return _labelView.font;
	}

	-(void) setFont:(UIFont *)font {
		_labelView.font = font;
	}

	-(void) setSelected:(BOOL)selected {
		_selected				= selected;
		_labelView.highlighted	= selected;
		[self setNeedsDisplay];
	}

@end
