
#import <UXKit/UXThumbView.h>
#import <UXKit/UXDefaultStyleSheet.h>

@implementation UXThumbView

	-(id) initWithFrame:(CGRect)frame {
		if (self = [super initWithFrame:frame]) {
			self.backgroundColor	= UXSTYLEVAR(thumbnailBackgroundColor);
			self.clipsToBounds		= YES;
			[self setStylesWithSelector:@"thumbView:"];
		}
		return self;
	}

	#pragma mark -

	-(NSString *) thumbURL {
		return [self imageForState:UIControlStateNormal];
	}

	-(void) setThumbURL:(NSString *)URL {
		[self setImage:URL forState:UIControlStateNormal];
	}


	#pragma mark -

	-(void) dealloc {
		[super dealloc];
	}

@end
