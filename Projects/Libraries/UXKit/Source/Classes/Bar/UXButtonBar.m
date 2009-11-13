
#import <UXKit/UXButtonBar.h>
#import <UXKit/UXButton.h>

static CGFloat kPadding			= 10;
static CGFloat kButtonHeight	= 30;
static CGFloat kButtonMaxWidth	= 120;

@implementation UXButtonBar

	@synthesize buttons		= _buttons;
	@synthesize buttonStyle = _buttonStyle;

	#pragma mark NSObject

	-(id) initWithFrame:(CGRect)frame {
		if (self = [super initWithFrame:frame]) {
			_buttons			= [[NSMutableArray alloc] init];
			_buttonStyle		= nil;
			self.buttonStyle	= @"toolbarButton:";
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_buttons);
		UX_SAFE_RELEASE(_buttonStyle);
		[super dealloc];
	}


	#pragma mark UIResponder

	-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
		// Hackish? This prevents weird things from happening when the user touches the
		// background of the button bar while it is used as the menu in a table view.
	}


	#pragma mark UIView

	-(void) layoutSubviews {
		CGFloat buttonWidth = floor((self.width - kPadding) / _buttons.count) - kPadding;
		if (buttonWidth > kButtonMaxWidth) {
			buttonWidth = kButtonMaxWidth;
		}
		
		CGFloat x = kPadding + floor(self.width / 2 - ((buttonWidth + kPadding) * _buttons.count) / 2);
		CGFloat y = floor(self.height / 2 - kButtonHeight / 2);
		
		for (UIButton *button in _buttons) {
			button.frame	= CGRectMake(x, y, buttonWidth, kButtonHeight);
			x				+= button.width + kPadding;
		}
	}

	#pragma mark public

	-(void) addButton:(NSString *)title target:(id)target action:(SEL)selector {
		UXButton *button = [UXButton buttonWithStyle:_buttonStyle];
		[button setTitle:title forState:UIControlStateNormal];
		[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:button];
		[_buttons addObject:button];
	}

	-(void) removeButtons {
		for (UIButton *button in _buttons) {
			[button removeFromSuperview];
		}
		[_buttons removeAllObjects];
	}

@end
