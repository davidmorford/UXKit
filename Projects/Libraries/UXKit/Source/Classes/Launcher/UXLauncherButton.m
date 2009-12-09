
#import <UXKit/UXLauncherButton.h>
#import <UXKit/UXLauncherItem.h>
#import <UXKit/UXLauncherView.h>
#import <UXKit/UXLabel.h>
#import <UXKit/UXDefaultStyleSheet.h>

static const NSInteger kMaxBadgeNumber = 99;

@implementation UXLauncherButton

	@synthesize item		= _item; 
	@synthesize closeButton = _closeButton; 
	@synthesize editing		= _editing;
	@synthesize dragging	= _dragging;


	#pragma mark SPI

	-(void) updateBadge {
		if (!_badge && _item.badgeNumber) {
			_badge							= [[UXLabel alloc] init];
			_badge.style					= UXSTYLEWITHSELECTOR(largeBadge);
			_badge.backgroundColor			= [UIColor clearColor];
			_badge.userInteractionEnabled	= NO;
			[self addSubview:_badge];
		}
		
		if (_item.badgeNumber > 0) {
			if (_item.badgeNumber <= kMaxBadgeNumber) {
				_badge.text = [NSString stringWithFormat:@"%d", _item.badgeNumber];
			}
			else {
				_badge.text = [NSString stringWithFormat:@"%d+", kMaxBadgeNumber];
			}
		}
		_badge.hidden = _item.badgeNumber <= 0;
		[_badge sizeToFit];
		[self setNeedsLayout];
	}

	#pragma mark NSObject

	-(id) initWithItem:(UXLauncherItem *)item {
		if (self = [self init]) {
			_item			= [item retain];
			NSString *title = [[NSBundle mainBundle] localizedStringForKey:item.title value:nil table:nil];
			[self setTitle:title forState:UIControlStateNormal];
			[self setImage:item.image forState:UIControlStateNormal];
			
			if (item.style) {
				[self setStylesWithSelector:item.style];
			}
			else {
				[self setStylesWithSelector:@"launcherButton:"];
			}
			[self updateBadge];
		}
		return self;
	}

	-(id) initWithFrame:(CGRect)frame {
		if (self = [super initWithFrame:frame]) {
			_item			= nil;
			_badge			= nil;
			_closeButton	= nil;
			_dragging		= NO;
			_editing		= NO;
			self.isVertical = YES;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_item);
		UX_SAFE_RELEASE(_badge);
		UX_SAFE_RELEASE(_closeButton);
		[super dealloc];
	}


	#pragma mark UIResponder

	-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
		[super touchesBegan:touches withEvent:event];
		[[self nextResponder] touchesBegan:touches withEvent:event];
	}

	-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
		[super touchesMoved:touches withEvent:event];
		[[self nextResponder] touchesMoved:touches withEvent:event];
	}

	-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
		[super touchesEnded:touches withEvent:event];
		[[self nextResponder] touchesEnded:touches withEvent:event];
	}


	#pragma mark UIControl

	-(BOOL) isHighlighted {
		return !_dragging && [super isHighlighted];
	}

	-(BOOL) isSelected {
		return !_dragging && [super isSelected];
	}


	#pragma mark UIView

	-(void) layoutSubviews {
		if (_badge || _closeButton) {
			CGRect imageRect = [self rectForImage];
			if (_badge) {
				_badge.origin = CGPointMake((imageRect.origin.x + imageRect.size.width) - (floor(_badge.width * 0.7)),
											imageRect.origin.y - (floor(_badge.height * 0.25)));
			}
			
			if (_closeButton) {
				_closeButton.origin = CGPointMake(imageRect.origin.x - (floor(_closeButton.width * 0.4)),
												  imageRect.origin.y - (floor(_closeButton.height * 0.4)));
			}
		}
	}

	#pragma mark API

	-(UXButton *) closeButton {
		if (!_closeButton && _item.canDelete) {
			_closeButton			= [[UXButton buttonWithStyle:@"launcherCloseButton:"] retain];
			[_closeButton setImage:@"bundle://UXKit.bundle/Images/Navigation/closeButton.png" forState:UIControlStateNormal];
			_closeButton.size		= CGSizeMake(26, 29);
			_closeButton.isVertical = YES;
		}
		return _closeButton;
	}

	-(void) setDragging:(BOOL)dragging {
		if (_dragging != dragging) {
			_dragging = dragging;
			if (dragging) {
				self.transform	= CGAffineTransformMakeScale(1.4, 1.4);
				self.alpha		= 0.7;
			}
			else {
				self.transform	= CGAffineTransformIdentity;
				self.alpha		= 1;
			}
		}
	}

	-(void) setEditing:(BOOL)editing {
		if (_editing != editing) {
			_editing = editing;
			if (editing) {
				[self addSubview:self.closeButton];
			}
			else {
				[_closeButton removeFromSuperview];
				UX_SAFE_RELEASE(_closeButton);
			}
		}
	}

@end
