
#import <UXKit/UXLink.h>
#import <UXKit/UXNavigator.h>
#import <UXKit/UXShape.h>
#import <UXKit/UXView.h>
#import <UXKit/UXDefaultStyleSheet.h>

@implementation UXLink

	@synthesize URL = _URL;

	-(void) linkTouched {
		UXOpenURL(_URL);
	}


	#pragma mark UIView

	-(id) initWithFrame:(CGRect)frame {
		if (self = [super initWithFrame:frame]) {
			_URL		= nil;
			_screenView = nil;
			self.userInteractionEnabled = FALSE;
			[self addTarget:self action:@selector(linkTouched) forControlEvents:UIControlEventTouchUpInside];
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_URL);
		UX_SAFE_RELEASE(_screenView);
		[super dealloc];
	}

	
	#pragma mark UIControl

	-(void) setHighlighted:(BOOL)highlighted {
		[super setHighlighted:highlighted];
		if (highlighted) {
			if (!_screenView) {
				_screenView					= [[UXView alloc] initWithFrame:self.bounds];
				_screenView.style			= UXSTYLEWITHSELECTOR(linkHighlighted);
				_screenView.backgroundColor = [UIColor clearColor];
				_screenView.userInteractionEnabled = NO;
				[self addSubview:_screenView];
			}
			
			_screenView.frame	= self.bounds;
			_screenView.hidden	= NO;
		}
		else {
			_screenView.hidden	= YES;
		}
	}

	-(BOOL) continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
		if ([self pointInside:[touch locationInView:self] withEvent:event]) {
			return YES;
		}
		else {
			self.highlighted = NO;
			return NO;
		}
	}

	
	#pragma mark -

	-(void) setURL:(id)URL {
		[_URL release];
		_URL = [URL retain];
		self.userInteractionEnabled = !!_URL;
	}

@end
