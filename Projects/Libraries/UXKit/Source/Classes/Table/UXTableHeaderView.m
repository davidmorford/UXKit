
#import <UXKit/UXTableHeaderView.h>
#import <UXKit/UXDefaultStyleSheet.h>

@implementation UXTableHeaderView

	-(id) initWithTitle:(NSString *)aTitle {
		if (self = [super init]) {
			self.backgroundColor	= [UIColor clearColor];
			self.style				= UXSTYLE(tableHeader);
			
			_label					= [[UILabel alloc] init];
			_label.text				= aTitle;
			_label.backgroundColor	= [UIColor clearColor];
			_label.textColor		= UXSTYLEVAR(tableHeaderTextColor) ? UXSTYLEVAR(tableHeaderTextColor) : UXSTYLEVAR(linkTextColor);
			_label.shadowColor		= UXSTYLEVAR(tableHeaderShadowColor) ? UXSTYLEVAR(tableHeaderShadowColor) : [UIColor clearColor];
			_label.shadowOffset		= CGSizeMake(0, -1);
			_label.font				= UXSTYLEVAR(tableHeaderPlainFont);
			[self addSubview:_label];
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_label);
		[super dealloc];
	}

	
	#pragma mark UIView

	-(void) layoutSubviews {
		_label.frame = CGRectMake(12, 0, self.width, self.height);
	}

@end

#pragma mark -

@implementation UXTableGroupedHeaderView

	-(id) initWithTitle:(NSString *)title {
		if (self = [super initWithTitle:title]) {
			self.style	= UXSTYLE(tableGroupedHeader);
			_label.font = UXSTYLEVAR(tableHeaderGroupedFont);
		}
		return self;
	}

@end
